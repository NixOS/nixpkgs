import unittest
import tempfile
import shutil
from pathlib import Path
from nix_required_mounts import (
    PathString,
    Pattern,
    expand_globs,
    mount_closure,
    prune_paths,
    symlink_targets,
    symlink_targets_deep,
)
import os
import pytest
from pathlib import Path


class TreeBuilder:
    """Helper to create files and symlinks from a simple dict."""

    def __init__(self, root: Path):
        self.root = root

    def build(self, structure: dict):
        for path_str, target in structure.items():
            path = self.root / path_str
            path.parent.mkdir(parents=True, exist_ok=True)

            if target == "file":
                path.touch()
            elif target == "dir":
                path.mkdir(parents=True, exist_ok=True)
            elif target.startswith("->"):
                link_to = target.replace("->", "").strip()
                path.symlink_to(link_to)
        return self.root


@pytest.fixture
def tree(tmp_path):
    # https://docs.pytest.org/en/stable/how-to/tmp_path.html
    # the paths are kept on error for inspection
    return TreeBuilder(tmp_path)


def test_symlink_chain(tree):
    # fmt: off
    root = tree.build({
        "a": "file",
        "b": "-> a",
        "c": "-> b",
    })
    # fmt: on

    assert symlink_targets(root / "a") == []
    assert symlink_targets(root / "b") == [root / "a"]
    assert symlink_targets(root / "c") == [root / "b", root / "a"]


def test_far_up_relative_links(tree):
    depth = 15
    path = "x/" * depth
    root = tree.build(
        {
            "o/p": "file",
            "a/b": f"-> ../{path}",
            f"{path}/n": f"-> ../{'../' * depth}o/p",
        }
    )

    assert symlink_targets(root / "a/b") == [root / Path(path)]


def test_jump_outside_folder(tree):
    # fmt: off
    root = tree.build({
        "c/d": "file",
        "a/b": "-> ../c/d",
    })
    # fmt: on
    assert symlink_targets(root / "a/b") == [root / "c/d"]


def test_path_discovery_resolve_relative_links(tree):
    depth = 15
    path = "x/" * depth
    root = tree.build(
        {
            "o/p": "file",
            "a/b": f"-> ../{path}",
            f"{path}/n": f"-> {'../' * depth}o/p",
        }
    )

    assert symlink_targets_deep([root / "a"], follow_symlinks=True) == [
        str(x) for x in [root / "a", root / path, root / "o/p"]
    ]


def test_pattern_extraction(tree):
    root = tree.build(
        {
            "a": "file",
            "b": "-> a",
            "c": "-> b",
            "d/e": "file",
            "f/g": "-> ../d/e",
        }
    )

    def strs(paths: list[Path]) -> list[PathString]:
        return [str(x) if isinstance(x, Path) else x for x in paths]

    def pairs(paths: list[Path]) -> list[tuple[str, str]]:
        return [(x, x) for x in strs(paths)]

    a = {
        "onFeatures": ["feature_a", "feature_a1"],
        "paths": [str(root / "c")],
        "unsafeFollowSymlinks": True,
    }

    assert mount_closure(a) == pairs([root / "a", root / "b", root / "c"])

    assert mount_closure(a | {"unsafeFollowSymlinks": False}) == pairs(
        [root / "c"]
    )

    b = {
        "onFeatures": ["feature_b", "feature_b2"],
        "paths": strs([root / "d", root / "f"]),
        "unsafeFollowSymlinks": True,
    }

    assert mount_closure(b) == pairs(
        [
            root / "d",
            root / "f",
        ]
    )

    with_mounts = {
        "onFeatures": ["feature_b", "feature_b2"],
        "paths": strs(
            [
                root / "d",  # prevent formatter
                root / "f",
                {"host": str(root), "guest": "/foo/bar"},
            ]
        ),
        "unsafeFollowSymlinks": True,
    }

    assert mount_closure(with_mounts) == [
        ("/foo/bar", str(root)),
    ]


def test_glob_expansion(tree):
    # fmt: off
    root = tree.build({
        "a": "file",
        "b": "-> a",
        "c": "-> b",
    })
    # fmt: on

    assert sorted(expand_globs([str(root / "*")])) == [
        str(x) for x in [root / "a", root / "b", root / "c"]
    ]


def test_path_discovery(tree):
    root = tree.build(
        {
            "a": "file",
            "b": "-> a",
            "c": "-> b",
            "d/e": "file",
            "f/g": "-> ../d/e",
        }
    )

    ss = lambda unsorted_paths: sorted(map(str, unsorted_paths))

    assert ss(
        symlink_targets_deep(
            [root / "c", root / "f"], follow_symlinks=True
        )
    ) == ss(
        # fmt: off
        [
            root / "a",
            root / "b",
            root / "c",
            root / "d/e",
            root / "f",
        ]
        # fmt: on
    )


if __name__ == "__main__":
    unittest.main()
