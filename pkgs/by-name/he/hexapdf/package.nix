{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  ruby,
}:

bundlerApp {
  pname = "hexapdf";
  exes = [ "hexapdf" ];

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "hexapdf";

  meta = with lib; {
    description = "Versatile PDF creation and manipulation library";
    homepage = "https://hexapdf.gettalong.org/";
    changelog = "https://github.com/gettalong/hexapdf/blob/master/CHANGELOG.md";
    license = with licenses; [
      agpl3Only
      unfree
    ];
    maintainers = with maintainers; [ bbenno ];
    platforms = platforms.unix;
    mainProgram = "hexapdf";
  };
}
