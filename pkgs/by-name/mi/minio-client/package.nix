{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "minio-client";
  version = "2025-03-12T17-29-24Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-8n/qjM+FBrjbSLcd9iVioh3iEAkMNrIo5fG/ZQkAmBo=";
  };

  vendorHash = "sha256-P7W8xgHc+2ksZnY0iuuPKjwsxSqjhPdiUfNMe18ldL0=";

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mc --version | grep ${version} > /dev/null
  '';

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "Replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ bachp ];
    mainProgram = "mc";
    license = licenses.asl20;
  };
}
