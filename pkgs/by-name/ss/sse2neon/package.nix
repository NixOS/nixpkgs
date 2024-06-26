{
  lib,
  fetchFromGitHub,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sse2neon";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "DLTcollab";
    repo = "sse2neon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-riFFGIA0H7e5StYSjO0/JDrduzfwS+lOASzk5BRUyo4=";
  };

  postPatch = ''
    # remove warning about gcc < 10
    substituteInPlace sse2neon.h --replace-fail "#warning \"GCC versions" "// "
  '';

  nativeBuildInputs = [ pkg-config ];

  dontInstall = true;
  # use postBuild instead of installPhase, because the build
  # in itself doesn't produce any ($out) output
  postBuild = ''
    mkdir -p $out/lib
    install -m444 sse2neon.h $out/lib/
  '';

  meta = {
    description = "Mono library that provides a GDI+-compatible API on non-Windows operating systems";
    homepage = "https://www.mono-project.com/docs/gui/libgdiplus/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gador ];
  };
})
