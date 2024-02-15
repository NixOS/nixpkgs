{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deepfilternet";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "Rikorose";
    repo = "DeepFilterNet";
    rev = "v${version}";
    hash = "sha256-5bYbfO1kmduNm9YV5niaaPvRIDRmPt4QOX7eKpK+sWY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hdf5-0.8.1" = "sha256-qWF2mURVblSLPbt4oZSVxIxI/RO3ZNcZdwCdaOTACYs=";
    };
  };

  # only the ladspa plugin part has been packaged so far...

  buildAndTestSubdir = "ladspa";

  postInstall = ''
    mkdir $out/lib/ladspa
    mv $out/lib/libdeep_filter_ladspa${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/ladspa/
  '';

  meta = {
    description = "Noise supression using deep filtering";
    homepage = "https://github.com/Rikorose/DeepFilterNet";
    license = with lib.licenses; [ mit asl20 ];
    maintainers = with lib.maintainers; [ ralismark ];
    changelog = "https://github.com/Rikorose/DeepFilterNet/releases/tag/${src.rev}";
  };
}
