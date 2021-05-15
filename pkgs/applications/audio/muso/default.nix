{ lib, fetchFromGitHub, rustPlatform
, pkg-config, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "muso";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "quebin31";
    repo = pname;
    rev = "68cc90869bcc0f202830a318fbfd6bb9bdb75a39";
    sha256 = "1dnfslliss173igympl7h1zc0qz0g10kf96dwrcj6aglmvvw426p";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  preConfigure = ''
    substituteInPlace lib/utils.rs \
      --replace "/usr/share/muso" "$out/share/muso"
  '';

  postInstall = ''
    mkdir -p $out/share/muso
    cp share/* $out/share/muso/
  '';

  cargoSha256 = "06jgk54r3f8gq6iylv5rgsawss3hc5kmvk02y4gl8iwfnw4xrvmg";

  meta = with lib; {
    description = "An automatic music sorter (based on ID3 tags)";
    homepage = "https://github.com/quebin31/muso";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ bloomvdomino ];
  };
}
