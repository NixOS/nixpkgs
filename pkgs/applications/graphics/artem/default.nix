{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "artem";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "finefindus";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jax39gizlcbqnkjckxwm5h0wdk5dk8dasaj9wxv7yidbcbgj4zh";
  };

  cargoSha256 = "sha256-n2NOWrgcMVHpNCHL7r8+Kl1e01XYadaNM7UdE8fQo1U=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ];

  OPENSSL_NO_VENDOR = 1;

  checkFlags = [
    # require internet access
    "--skip=arguments::input::url_input"
    "--skip=full_file_compare_url"

    # flaky
    "--skip=full_file_compare_html"
  ];

  postInstall = ''
    installManPage $releaseDir/build/artem-*/out/artem.1
    installShellCompletion $releaseDir/build/artem-*/out/artem.{bash,fish} \
      --zsh $releaseDir/build/artem-*/out/_artem
  '';

  meta = with lib; {
    description = "A small CLI program to convert images to ASCII art";
    homepage = "https://github.com/finefindus/artem";
    changelog = "https://github.com/finefindus/artem/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
