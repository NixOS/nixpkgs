{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
, fetchpatch
, glibc
}:

buildGoModule rec {
  pname = "toolbox";
  version = "0.0.99";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "toolbox";
    rev = version;
    sha256 = "CKjndWXDLxQ5epco/+TwRFxftbeMhYp/7NOWglF6EL8=";
  };

  modRoot = "src";

  patches = [
    ./toolbox_glibc.patch
    (fetchpatch {
      url = "https://github.com/containers/toolbox/commit/14cacc4ea6dc8fc51cb1e6bffa221e2dbcb61a0b.patch";
      sha256 = "DFakCVBj/RgKU5pem3KxKgjorl8FNlHApR56wxWpkpA=";
    })
    (fetchpatch {
      url = "https://github.com/containers/toolbox/commit/a0f34e65c0c6b25b9300ed5f511403a29943a06a.patch";
      sha256 = "9PZ7pDKlvkpEBQMyfR089nkDvRNRQ4Xzcij3ku1cdqE=";
    })
  ];

  postPatch = ''
    substituteInPlace src/cmd/create.go --subst-var-by glibc ${glibc}
  '';

  vendorSha256 = "06s97kpbw40571jjp96jpld1qxb2frd4akcrwwxi1minvs24lb5p";

  buildFlagsArray = [
    "-ldflags=-X github.com/containers/toolbox/pkg/version.currentVersion=${version}"
  ];

  nativeBuildInputs = [
    go-md2man
    installShellFiles
  ];

  preConfigure = ''
    substituteInPlace src/cmd/create.go \
      --replace '"/etc/profile.d/toolbox.sh"}' '"${placeholder "out"}/share/profile.d/toolbox.sh"}'
  '';

   postInstall = ''
     cd ..
     for d in doc/*.md; do
       go-md2man -in $d -out ''${d%.md}
     done
     installManPage doc/*.[1-9]
     installShellCompletion --bash completion/bash/toolbox
     install profile.d/toolbox.sh -Dt $out/share/profile.d
 '';

  meta = with lib; {
    description = "Unprivileged development environment";
    homepage = "https://github.com/containers/toolbox";
    license = licenses.asl20;
    maintainers = with maintainers; [ mjlbach ];
    platforms = platforms.linux;
  };
}
