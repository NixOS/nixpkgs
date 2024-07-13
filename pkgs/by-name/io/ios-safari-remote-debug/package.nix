{
  lib,
  buildGoModule,
  fetchFromGitea,
}:

buildGoModule rec {
  pname = "ios-safari-remote-debug";
  version = "unstable-2024-04-25";

  src = fetchFromGitea {
    domain = "git.gay";
    owner = "besties";
    repo = "ios-safari-remote-debug";
    rev = "a6c9886e60eeaceb753900d628500befc5c9ffc2";
    hash = "sha256-954ZLhwxjpc7+Ocne/yXzBl6FFKuNbGLxheZnlrxmZE=";
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

  meta = with lib; {
    description = "A remote debugger for iOS Safari";
    homepage = "https://git.gay/besties/ios-safari-remote-debug";
    license = licenses.unfree;
    mainProgram = "ios-safari-remote-debug";
    maintainers = with maintainers; [ paveloom ];
  };
}
