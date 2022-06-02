{ lib, stdenv, fetchFromGitHub, rustPlatform
, pkg-config, wrapGAppsHook, CoreServices
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
  buildInputs = lib.optional stdenv.isDarwin CoreServices;

  preConfigure = ''
    substituteInPlace lib/utils.rs \
      --replace "/usr/share/muso" "$out/share/muso"
  '';

  postInstall = ''
    mkdir -p $out/share/muso
    cp share/* $out/share/muso/
  '';

  cargoSha256 = "1hgdzyz005244f2mh97js9ga0a6s2hcd6iydz07f1hmhsh1j2bwy";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "An automatic music sorter (based on ID3 tags)";
    homepage = "https://github.com/quebin31/muso";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ bloomvdomino ];
  };
}
