{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "flgen";
  gemdir = ./.;
  exes = [ "flgen" ];

  meta = {
    description = "Filelist generator";
    longDescription = ''
      FLGen provides a DSL to write filelists and generator tool to generate a
      filelist which is given to EDA tools.
    '';
    homepage = "https://github.com/pezy-computing/flgen";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.parthkalgaonkar ];
  };
}
