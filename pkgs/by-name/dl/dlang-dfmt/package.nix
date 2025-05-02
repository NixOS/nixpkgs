{
  lib,
  stdenv,
  fetchFromGitHub,
  ldc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dlang-dfmt";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dfmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9bLoTC88Y/Ud5+iIDPGxjsy5j0Ifk02E9vWcwiGQM+E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ ldc ];

  buildFlags = [ "ldc" ];

  preBuild = ''
    mkdir bin
    echo ${finalAttrs.version} >bin/githash.txt
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = {
    description = "Formatter for D source code";
    homepage = "https://github.com/dlang-community/dfmt";
    license = lib.licenses.boost;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jtbx ];
  };
})
