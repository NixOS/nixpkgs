{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
  curl,
  cli11,
  python3,
  pkg-config,
  catch2_3,
}:

let
  thread-pool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    tag = "v5.0.0";
    hash = "sha256-1TTpt6u3NVIMSExl0ttuwH2owQCetujolnR/t8hDMh0=";
  };

  gcem = fetchFromGitHub {
    owner = "klytje";
    repo = "gcem";
    rev = "c5464969d373ed0a763c3562656798d1cc00687f";
    hash = "sha256-bnWakLHl/afpeFm6S32ku0IkniyIs8X+LE1NmV6p0ho=";
  };

  pocketfft = fetchFromGitHub {
    owner = "mreineck";
    repo = "pocketfft";
    rev = "c90e55b3d529f8efa40ed01a20de22405f45fc65";
    hash = "sha256-K3yvh6i5f9VbAiQPyixgnlDCj4eBWPU8m3BNn+fScdM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ausaxs";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "AUSAXS";
    repo = "AUSAXS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3w1bTO2qWUic/1Js4VC7YAne20JegPwCWbfChq5lzy0=";
  };

  patches = [ ./cmake-no-fetchcontent.patch ];

  postPatch = ''
    cp --recursive --no-preserve=mode ${thread-pool} thread_pool
    cp --recursive --no-preserve=mode ${gcem} gcem
    cp --recursive --no-preserve=mode ${pocketfft} pocketfft
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    python3
    pkg-config
  ];

  buildInputs = [
    catch2_3
    curl
    cli11
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_SYSTEM_CATCH" true)
    (lib.cmakeBool "USE_SYSTEM_CLI11" true)
  ];

  postInstall = ''
    cp --recursive lib/* $out/lib/
    cp --recursive bin $out/bin
    cp --recursive ../scripts $out/bin/scripts
  '';

  meta = {
    description = "Small-angle X-ray scattering framework";
    homepage = "https://github.com/AUSAXS/AUSAXS";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.unix;
  };
})
