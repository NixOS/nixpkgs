{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libllvm,
}:

buildGoModule {
  pname = "pprof";
  version = "0-unstable-2026-09-03";

  src = fetchFromGitHub {
    owner = "google";
    repo = "pprof";
    rev = "d6c3cb2f37ec22719bbaf5eb031d9a46635cb5b2";
    hash = "sha256-2LflblPAds0JRZZPvxW986cgXCMV+R3qikLt9w+9vU0=";
  };

  nativeCheckInputs = [
    libllvm
  ];

  postPatch = ''
    rm -rf browsertests   # somewhat independent module to ignore.
  '';

  vendorHash = "sha256-nGBPg0OV6sOSpKEY+EPt9v5eIm/3OrxNYLJDOcdDwio=";

  meta = {
    description = "Tool for visualization and analysis of profiling data";
    homepage = "https://github.com/google/pprof";
    license = lib.licenses.asl20;
    longDescription = ''
      pprof reads a collection of profiling samples in profile.proto format and
      generates reports to visualize and help analyze the data. It can generate
      both text and graphical reports (through the use of the dot visualization
      package).

      profile.proto is a protocol buffer that describes a set of callstacks and
      symbolization information. A common usage is to represent a set of sampled
      callstacks from statistical profiling. The format is described on the
      proto/profile.proto file. For details on protocol buffers, see
      https://developers.google.com/protocol-buffers

      Profiles can be read from a local file, or over http. Multiple profiles of
      the same type can be aggregated or compared.

      If the profile samples contain machine addresses, pprof can symbolize them
      through the use of the native binutils tools (addr2line and nm).

      This is not an official Google product.
    '';
    mainProgram = "pprof";
    maintainers = with lib.maintainers; [
      hzeller
      lromor
    ];
  };
}
