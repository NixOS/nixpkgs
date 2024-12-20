{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, asio, openssl, zlib }:

stdenv.mkDerivation rec {
  pname = "nuraft";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "eBay";
    repo = "NuRaft";
    rev = "v${version}";
    sha256 = "sha256-puO8E7tSLqB0oq/NlzEZqQgIZKm7ZUb4HhR0XuI9dco=";
  };

  patches = [
    # Fix gcc-13 build failure:
    #   https://github.com/eBay/NuRaft/pull/435
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/eBay/NuRaft/commit/fddf33a4d8cd7fcd0306cc838a30893a4df3d58f.patch";
      hash = "sha256-JOtR3llE4QwQM7PBx+ILR87zsPB0GZ/aIKbSdHIrePA=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost asio openssl zlib ];

  meta = with lib; {
    homepage = "https://github.com/eBay/NuRaft";
    description = "C++ implementation of Raft core logic as a replication library";
    license = licenses.asl20;
    maintainers = with maintainers; [ wheelsandmetal ];
    platforms = platforms.all;
  };
}
