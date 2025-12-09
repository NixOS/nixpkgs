{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "networking-ts-cxx";
  version = "2019-02-27";

  # Used until https://github.com/chriskohlhoff/networking-ts-impl/issues/17 is
  # resolved and we can generate in Nix.
  src = fetchFromGitHub {
    owner = "chriskohlhoff";
    repo = "networking-ts-impl";
    rev = "c97570e7ceef436581be3c138868a19ad96e025b";
    sha256 = "12b5lg989nn1b8v6x9fy3cxsf3hs5hr67bd1mfyh8pjikir7zv6j";
  };

  installPhase = ''
    mkdir -p $out/{include,lib/pkgconfig}
    cp -r include $out/
    substituteAll ${./networking_ts.pc.in} $out/lib/pkgconfig/networking_ts.pc
  '';

  meta = with lib; {
    description = "Experimental implementation of the C++ Networking Technical Specification";
    homepage = "https://github.com/chriskohlhoff/networking-ts-impl";
    license = licenses.boost;
  };
}
