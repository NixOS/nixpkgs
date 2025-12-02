{
  ffmpeg,
  python3Packages,
}:

python3Packages.toPythonApplication (
  python3Packages.beets.override {
    inherit ffmpeg;
  }
)
