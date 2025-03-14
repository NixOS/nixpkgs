{
  lib,
  fetchFromGitHub,
  makeWrapper,
  jujutsu,
  rustPlatform,
  testers,
  lazyjj,
}:
rustPlatform.buildRustPackage rec {
  pname = "lazyjj";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    rev = "v${version}";
    hash = "sha256-Pz2q+uyr8r5G5Zs5mC/nvHdK6hTpiLBzjgUmvd5dwZw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-70xKyzRFMyAKhSwEsdNBK2afs0UpVoTvIXuQJgeqYY8=";

  postInstall = ''
    wrapProgram $out/bin/lazyjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ jujutsu ];

  passthru.tests.version = testers.testVersion { package = lazyjj; };

  meta = with lib; {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    mainProgram = "lazyjj";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
