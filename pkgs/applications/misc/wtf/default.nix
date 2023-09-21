{ buildGoModule
, fetchFromGitHub
, lib
, makeWrapper
, ncurses
, stdenv
}:

buildGoModule rec {
  pname = "wtf";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "wtfutil";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DFrA4bx+wSOxmt1CVA1oNiYVmcWeW6wpfR5F1tnhyDY=";
  };

  vendorHash = "sha256-9uuLidieBMoKz/FLcBnp9wenyveOIzB0IvRBRasulZk=";
  proxyVendor = true;

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv "$out/bin/wtf" "$out/bin/wtfutil"
    wrapProgram "$out/bin/wtfutil" --prefix PATH : "${ncurses.dev}/bin"
  '';

  meta = with lib; {
    description = "The personal information dashboard for your terminal";
    homepage = "https://wtfutil.com/";
    changelog = "https://github.com/wtfutil/wtf/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "wtfutil";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
