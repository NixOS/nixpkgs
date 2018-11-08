{ stdenv, fetchurl, rustPlatform, darwin, openssl, libsodium, pkgconfig }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "1lkipcp83rfsj9yqddvb46dmqdf2ch9njwvjv8f3g91rmfjcngys";
  };

  cargoPatches = [
    ./libpijul.patch
  ];

  nativeBuildInputs = [ pkgconfig ];

  postInstall = ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d}
    $out/bin/pijul generate-completions --bash > $out/share/bash-completion/completions/pijul
    $out/bin/pijul generate-completions --zsh > $out/share/zsh/site-functions/_pijul
    $out/bin/pijul generate-completions --fish > $out/share/fish/vendor_completions.d/pijul.fish
  '';

  buildInputs = [ openssl libsodium ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  cargoSha256 = "1419mlxa4p53hm5qzfd1yi2k0n1bcv8kaslls1nyx661vknhfamw";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
