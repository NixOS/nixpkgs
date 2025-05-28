from pathlib import Path
from runpy import run_path

pkg_dir = Path(__file__).resolve().parent

def execute_main():
    script_pth = pkg_dir / "main.py"
    run_path(str(script_pth), run_name="__main__")
