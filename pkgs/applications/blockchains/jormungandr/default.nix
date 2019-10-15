{ stdenv
, lib
, fetchgit
, rustPlatform
, openssl
, pkgconfig
, protobuf
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jormungandr";
  version = "0.5.6";

  src = fetchgit {
    url = "https://github.com/input-output-hk/${pname}";
    rev = "v${version}+lock";
    sha256 = "0l6rxr1xjp5hfkf0qfx8qsa1slxn0ly28akci1rwgdhlzjn43zqr";
    fetchSubmodules = true;
  };

  cargoSha256 = "0590gsghr25bzfmxfyrpg58a0l77y88jwnrkgjxf06x3d66kkn3l";

  nativeBuildInputs = [ pkgconfig protobuf ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  patchPhase = ''
    sed -i "s~SCRIPTPATH=.*~SCRIPTPATH=$out/templates/~g" scripts/bootstrap
  '';

  installPhase = ''
    install -d $out/bin $out/templates
    install -m755 target/*/release/jormungandr $out/bin/
    install -m755 target/*/release/jcli $out/bin/
    install -m755 target/*/release/jormungandr-scenario-tests	$out/bin/
    install -m755 scripts/send-transaction $out/templates
    install -m755 scripts/jcli-helpers $out/bin/
    install -m755 scripts/bootstrap $out/bin/jormungandr-bootstrap
    install -m644 scripts/faucet-send-money.shtempl $out/templates/
    install -m644 scripts/create-account-and-delegate.shtempl $out/templates/
    install -m644 scripts/faucet-send-certificate.shtempl $out/templates/
  '';

  PROTOC = "${protobuf}/bin/protoc";

  # Disabling integration tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An aspiring blockchain node";
    homepage = "https://input-output-hk.github.io/jormungandr/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.all;
  };
}
