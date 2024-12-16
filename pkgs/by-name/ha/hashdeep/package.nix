{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "hashdeep";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "jessek";
    repo = "hashdeep";
    rev = "release-${version}";
    sha256 = "0m2b042ndikavmplv3qjdhfj44hl1h8car83c192xi9nv5ahi7mf";
  };

  patches = [
    (fetchpatch {
      # Relevant link: <https://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#1512>
      # Defect report fixed in GCC 11
      # Search for "DR 1512" in <https://gcc.gnu.org/gcc-11/changes.html>
      name = "fix-cpp-defect-report-1512.patch";
      url = "https://github.com/jessek/hashdeep/commit/6ef69a26126ee4e69a25392fd456b8a66c51dffd.patch";
      sha256 = "sha256-IrqcnrKINeoh56FR25FzSM1YJMkM2yFd/GwOeWGRLFo=";
    })
    (fetchpatch {
      # Fix the spacing between the string literals and macros, see https://github.com/jessek/hashdeep/pull/385
      name = "string-literal-spacing.patch";
      url = "https://github.com/jessek/hashdeep/commit/18a6b5d57f7a648d2b7dcc6e50ff00a1e4b05fcc.patch";
      sha256 = "sha256-S6hzC8jPtG3ozsvVq5JfAUMwqKxytLGwBAtNYNr6RJ0=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Set of cross-platform tools to compute hashes";
    homepage = "https://github.com/jessek/hashdeep";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.karantan ];
    platforms = platforms.all;
  };
}
