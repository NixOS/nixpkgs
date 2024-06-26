{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "cobalt";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "cobalt-org";
    repo = "cobalt.rs";
    rev = "v${version}";
    sha256 = "sha256-aAhceExz5SENL+FhPHyx8HmaNOWjNsynv81Rj2cS5M8=";
  };

  cargoHash = "sha256-vw7fGsTSEVO8s1LzilKJN5lGzOfQcms1h7rnTOyE4Kw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Static site generator written in Rust";
    homepage = "https://github.com/cobalt-org/cobalt.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.unix;
    mainProgram = "cobalt";
  };
}
