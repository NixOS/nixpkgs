{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  makeWrapper,
  python3Packages,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "argbash";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "matejak";
    repo = "argbash";
    rev = finalAttrs.version;
    hash = "sha256-B8581sA3dxmHiJqQhmXSChiWaPIFqiLLFUMnwAlCLJs=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace resources/Makefile \
      --replace '/bin/bash' "${runtimeShell}"
  '';

  nativeBuildInputs = [
    autoconf
    makeWrapper
    python3Packages.docutils
  ];

  makeFlags = [
    "-C"
    "resources"
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/argbash \
      --prefix PATH : '${autoconf}/bin'
  '';

  meta = {
    homepage = "https://argbash.dev/";
    description = "Bash argument parsing code generator";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
