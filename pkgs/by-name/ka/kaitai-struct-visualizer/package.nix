{
  bundlerApp,
  bundlerUpdateScript,
  kaitai-struct-compiler,
  kaitai-struct-visualizer,
  lib,
  makeWrapper,
  ruby_3_5,
  testers,
}:

(bundlerApp.override { ruby = ruby_3_5; }) {
  pname = "kaitai-struct-visualizer";

  gemdir = ./.;

  exes = [
    "ksdump"
    "ksv"
  ];

  passthru = {
    tests = {
      version = testers.testVersion {
        package = kaitai-struct-visualizer;
        version = with kaitai-struct-visualizer; ''
          kaitai-struct-visualizer ${version}
          kaitai-struct-compiler ${version}
          kaitai-struct ${version} (Kaitai Struct runtime library for Ruby)
        '';
      };
    };

    updateScript = bundlerUpdateScript "kaitai-struct-compiler";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/ksdump --prefix PATH : ${
      lib.makeBinPath [
        kaitai-struct-compiler
      ]
    }
    wrapProgram $out/bin/ksv --prefix PATH : ${
      lib.makeBinPath [
        kaitai-struct-compiler
      ]
    }
  '';

  meta = with lib; {
    description = "Console visualizer for the Kaitai Struct project";
    homepage = "https://github.com/kaitai-io/kaitai_struct_visualizer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jacobkoziej
    ];
    mainProgram = "ksv";
  };
}
