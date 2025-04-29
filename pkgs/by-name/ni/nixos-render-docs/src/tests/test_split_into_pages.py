import json
import unittest
import shutil
from pathlib import Path

from nixos_render_docs.manual import HTMLConverter, HTMLParameters
from nixos_render_docs.redirects import Redirects, RedirectsError


def setup_test(sample_path: Path, test_path: Path):
    shutil.copytree(sample_path, test_path, dirs_exist_ok=True)
    redirects = Redirects(json.loads((test_path / "redirects.json").open().read()), '')
    return HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path("")), {}, redirects)

def run_test(test_path: Path, md: HTMLConverter):
    md.convert(test_path / 'index.md', test_path / 'index.html')

def test_chapters(tmp_path):
    """Test adding a new identifier to the source."""

    md = setup_test(Path(__file__).parent / "samples/chapters", tmp_path)
    run_test(tmp_path, md)

