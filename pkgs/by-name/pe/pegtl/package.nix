{
  cmake,
  fetchFromGitHub,
  gitUpdater,
  lib,
  ninja,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pegtl";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = "PEGTL";
    rev = finalAttrs.version;
    hash = "sha256-nPWSO2wPl/qenUQgvQDQu7Oy1dKa/PnNFSclmkaoM8A=";
  };

  # GCC 16.1.0 has a bug with `__PRETTY_FUNCTION__` that leads to static
  # assertions in PEGTL failing. Upstream has enabled a workaround for GCC 16
  # specifically instead, and the bug was fixed for GCC 17+. The upstream patch
  # does not apply cleanly since the codebase has changed substantially since
  # v3.2.8, but it's trivial to apply a similar trick on our own.
  # https://github.com/taocpp/PEGTL/issues/382
  # https://github.com/taocpp/PEGTL/commit/0176e87da3a02d0ab40ce39f03e0e4108d1bbba5
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91155
  postPatch = ''
    substituteInPlace include/tao/pegtl/demangle.hpp --replace-fail \
      "#elif( __GNUC__ == 9 ) && ( __GNUC_MINOR__ < 3 )" \
      "#elif ( ( __GNUC__ == 9 ) && ( __GNUC_MINOR__ < 3 ) ) || ( __GNUC__ == 16 )"
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/taocpp/pegtl";
    description = "Parsing Expression Grammar Template Library";
    longDescription = ''
      Zero-dependency C++ header-only parser combinator library
      for creating parsers according to a Parsing Expression Grammar (PEG).
    '';
    license = lib.licenses.boost;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
