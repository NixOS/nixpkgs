{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-cal,
  aws-c-common,
  aws-c-io,
  aws-checksums,
  nix,
  s2n-tls,
  libexecinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aws-c-event-stream";
  # nixpkgs-update: no auto update
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "aws-c-event-stream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J8bcDIK6rEM2AyhTiRvPA2ikbv8gfDxEY8izuKLBNac=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    aws-c-cal
    aws-c-common
    aws-c-io
    aws-checksums
    s2n-tls
  ]
  ++ lib.optional stdenv.hostPlatform.isMusl libexecinfo;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = {
    description = "C99 implementation of the vnd.amazon.eventstream content-type";
    homepage = "https://github.com/awslabs/aws-c-event-stream";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
