{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libgit2
, patch
}:

buildGoModule rec {
  version = "0.2.5";
  pname = "gitin";

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = "gitin";
    rev = "v${version}";
    sha256 = "0x509dwfymy7zh4mfy5s42lsq3m5fzgalx3sz3aikg867jdcbncq";
    # gitin replaces git2go with a statically build local one and
    # also depends on an older version of libgit2, so we need to
    # update git2go. We need to these changes in postFetch since
    # buildGoModule doesn't execute patchPhase for the vendoring
    # step.
    # https://github.com/isacikgoz/gitin/issues/71
    extraPostFetch = ''
      ${patch}/bin/patch -p1 -d$out < ${./git2go-v31.patch}
    '';
  };

  vendorSha256 = "08cvap7x138ccvmwn2cjh49k77p1q66lmdl1gy4x6kal332r27gj";

  subPackages = [ "cmd/gitin" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgit2 ];

  meta = with lib; {
    homepage = "https://github.com/isacikgoz/gitin";
    description = "Text-based user interface for git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kimat ];
  };
}
