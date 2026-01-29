import json
import unittest
import shutil
from pathlib import Path

import nixos_render_docs
from nixos_render_docs.manual import HTMLConverter, HTMLParameters
from nixos_render_docs.redirects import Redirects, RedirectsError


def setup_test(sample_path: Path, test_path: Path):
    shutil.copytree(sample_path, test_path, dirs_exist_ok=True)

    with open(Path(nixos_render_docs.__file__).parent / "redirects.js") as redirects_script:
        redirects = Redirects(json.loads((test_path / "redirects.json").open().read()), redirects_script.read())
        return HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path(""), True), {}, redirects)

def run_test(test_path: Path, md: HTMLConverter):
    md.convert(test_path / 'index.md', test_path / 'index.html')

def test_chapters(tmp_path: Path):
    """Test adding a new identifier to the source."""

    md = setup_test(Path(__file__).parent / "samples/test_chapters", tmp_path)
    run_test(tmp_path, md)

    for f in tmp_path.iterdir():
        shutil.copytree(tmp_path, "/tmp/generated_test", dirs_exist_ok=True)

