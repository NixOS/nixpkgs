{
  lib,
  stdenv,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:

let
  pname = "s3proxy";
  version = "2.1.0";
in
maven.buildMavenPackage {
  inherit pname version;
  mvnHash = "sha256-85mE/pZ0DXkzOKvTAqBXGatAt8gc4VPRCxmEyIlyVGI=";

  src = fetchFromGitHub {
    owner = "gaul";
    repo = pname;
    rev = "s3proxy-${version}";
    hash = "sha256-GhZPvo8wlXInHwg8rSmpwMMkZVw5SMpnZyKqFUYLbrE=";
  };

  doCheck = !stdenv.isDarwin;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D --mode=644 --target-directory=$out/share/s3proxy target/s3proxy-${version}-jar-with-dependencies.jar

    makeWrapper ${jre}/bin/java $out/bin/s3proxy \
      --add-flags "-jar $out/share/s3proxy/s3proxy-${version}-jar-with-dependencies.jar"
  '';

  meta = with lib; {
    description = "Access other storage backends via the S3 API";
    mainProgram = "s3proxy";
    homepage = "https://github.com/gaul/s3proxy";
    changelog = "https://github.com/gaul/s3proxy/releases/tag/s3proxy-${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ camelpunch ];
  };
}
