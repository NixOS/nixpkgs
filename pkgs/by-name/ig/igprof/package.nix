{
  lib,
  stdenv,
  fetchFromGitHub,
  libunwind,
  cmake,
  pcre2,
  gdb,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.0.0";
  pname = "igprof";

  src = fetchFromGitHub {
    owner = "igprof";
    repo = "igprof";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RIDnilCoYlq0D9CBJKMX1zg1DBQ4RPcOlfGcZ2xosUo=";
  };

  buildInputs = [
    libunwind
    gdb
    pcre2
  ];
  nativeBuildInputs = [ cmake ];

  env.CXXFLAGS = toString [
    "-fPIC"
    "-O2"
    "-w"
    "-fpermissive"
  ];

  meta = {
    description = "Ignominous Profiler";

    longDescription = ''
      IgProf is a fast and light weight profiler. It correctly handles
      dynamically loaded shared libraries, threads and sub-processes started by
      the application.  We have used it routinely with large C++ applications
      consisting of many hundreds of shared libraries and thousands of symbols
      from millions of source lines of code. It requires no special privileges
      to run. The performance reports provide full navigable call stacks and
      can be customised by applying filters. Results from any number of
      profiling runs can be included. This means you can both dig into the
      details and see the big picture from combined workloads.
    '';

    license = lib.licenses.gpl2;

    homepage = "https://igprof.org/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ktf ];
  };
})
