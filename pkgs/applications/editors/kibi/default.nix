{ lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "kibi";
  version = "0.2.2";

  cargoSha256 = "sha256-ebUCkcUACganeq5U0XU4VIGClKDZGhUw6K3WBgTUUUw=";

  src = fetchFromGitHub {
    owner = "ilai-deutel";
    repo = "kibi";
    rev = "v${version}";
    sha256 = "sha256-ox1qKWxJlUIFzEqeyzG2kqZix3AHnOKFrlpf6O5QM+k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -Dm644 syntax.d/* -t $out/share/kibi/syntax.d
    wrapProgram $out/bin/kibi --prefix XDG_DATA_DIRS : "$out/share"
  '';

  meta = with lib; {
    description = "A text editor in ≤1024 lines of code, written in Rust";
    homepage = "https://github.com/ilai-deutel/kibi";
    license = licenses.mit;
    maintainers = with maintainers; [ robertodr ];
    mainProgram = "kibi";
  };
}
