{
  lib,
  stdenv,
  fetchFromGitHub,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ovh-ttyrec";
  version = "1.2.0.0";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "ovh-ttyrec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UC0+LW4iheVasCEznXw+OTyxMt3hO59gFhB2YiXCFZI=";
  };

  nativeBuildInputs = [ zstd ];

  installPhase = ''
    mkdir -p $out/{bin,man}
    cp ttytime ttyplay ttyrec $out/bin
    cp docs/*.1 $out/man
  '';

  meta = {
    homepage = "https://github.com/ovh/ovh-ttyrec/";
    description = "Terminal interaction recorder and player";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zimbatm ];
  };
})
