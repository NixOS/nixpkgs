{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.13.34";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "0p0nkqvkir6lriq75ingpfywn2yvyn3l35yxzk4aiq6vr2n7h3mw";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "1mzc6rnqcv97dlkl4j4p180f46wlyq45lc6nq7gqw396wc6m04km";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
