{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "deepfilternet";
  version = "0.5.6-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "Rikorose";
    repo = "DeepFilterNet";
    rev = "f1d19bffbeccd98a616f23c89903a2386a1d1dba";
    hash = "sha256-6NR+7FzXy30zamrP9u7HsTnyTqp3J3JG+QndVuL5q/g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "hdf5-0.8.1" = "sha256-qWF2mURVblSLPbt4oZSVxIxI/RO3ZNcZdwCdaOTACYs=";
    };
  };

  postPatch = ''
    ln --force -s ${./Cargo.lock} Cargo.lock
  '';

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
