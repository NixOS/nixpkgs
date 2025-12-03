{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "ios-safari-remote-debug";
  version = "unstable-2024-09-09";

  src = fetchFromGitea {
    domain = "git.gay";
    owner = "besties";
    repo = "ios-safari-remote-debug";
    rev = "b3c69873997c08fce83c48a5ab42f5a2354efdf2";
    hash = "sha256-Hh/CeH0ba4uPMlEo+OZ3w36pTpsW6OLtYIE5v6dkUjo=";
  };

  vendorHash = "sha256-O8Dr4UAISZmCUGao0cBnAx4dUJm6+u4Swiw0H5NVeeA=";

  patches = [ ./add-permissions-to-the-output-directory.patch ];

  postPatch = ''
    substituteInPlace build/build.go \
      --replace-fail 'cp.Copy("' 'cp.Copy("${placeholder "out"}/share/${pname}/'
  '';

  postBuild = ''
    mkdir -p $out/share/${pname}
    cp -r injectedCode views $out/share/${pname}
  '';

  meta = {
    description = "Remote debugger for iOS Safari";
    homepage = "https://git.gay/besties/ios-safari-remote-debug";
    license = lib.licenses.agpl3Plus;
    mainProgram = "ios-safari-remote-debug";
    maintainers = [ ];
  };
}
