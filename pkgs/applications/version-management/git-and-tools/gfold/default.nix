{ lib, fetchFromGitHub, gitMinimal, makeWrapper, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "gfold";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "0ss6vfrc6h3jlh5qilh82psd3vdnfawf1wl4cf64mfm4hm9dda63";
  };

  cargoSha256 = "09ywwgxm8l1p0jypp65zpqryjnb2g4gririf1dmqb9148dsj29x2";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram "$out/bin/gfold" --prefix PATH : "${gitMinimal}/bin"
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description =
      "A tool to help keep track of your Git repositories, written in Rust";
    license = licenses.asl20;
    maintainers = [ maintainers.shanesveller ];
    platforms = platforms.unix;
  };
}
