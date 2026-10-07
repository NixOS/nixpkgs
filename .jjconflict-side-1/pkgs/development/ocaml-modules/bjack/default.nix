{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libsamplerate,
  libjack2,
}:

buildDunePackage (finalAttrs: {
  pname = "bjack";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-bjack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jIxxqBVWphWYyLh+24rTxk4WWfPPdGCvNdevFJEKw70=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    libsamplerate
    libjack2
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-bjack";
    description = "Blocking API for the jack audio connection kit";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
