{
  stdenv,
  lib,
  fetchFromGitHub,
  asciidoc,
  cmake,
  docbook_xsl,
  pkg-config,
  bash-completion,
  openssl,
  curl,
  libxml2,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "lastpass-cli";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lastpass";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F/E8Y9aSkx5fhra+ppVsO/NXP28RF+QoGBzUccTfjRQ=";
  };

  nativeBuildInputs = [
    asciidoc
    cmake
    docbook_xsl
    pkg-config
  ];

  buildInputs = [
    bash-completion
    curl
    openssl
    libxml2
    libxslt
  ];

  installTargets = [
    "install"
    "install-doc"
  ];

  postInstall = ''
    install -Dm644 -T ../contrib/lpass_zsh_completion $out/share/zsh/site-functions/_lpass
    install -Dm644 -T ../contrib/completions-lpass.fish $out/share/fish/vendor_completions.d/lpass.fish
    install -Dm755 -T ../contrib/examples/git-credential-lastpass $out/bin/git-credential-lastpass
  '';

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage = "https://github.com/lastpass/lastpass-cli";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vinylen ];
  };
}
