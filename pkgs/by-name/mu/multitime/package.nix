{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "multitime";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "multitime";
    rev = "multitime-${version}";
    sha256 = "1p6m4gyy6dw7nxnpsk32qiijagmiq9vwch0fbc25qvmybwqp8qc0";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Time command execution over multiple executions";

    longDescription = ''
      Unix's `time` utility is a simple and often effective way of measuring
      how long a command takes to run. Unfortunately, running a command once
      can give misleading timings: the process may create a cache on its first
      execution, running faster subsequently; other processes may cause the
      command to be starved of CPU or IO time; etc. It is common to see people
      run `time` several times and take whichever values they feel most
      comfortable with. Inevitably, this causes problems.

      `multitime` is, in essence, a simple extension to time which runs a
      command multiple times and prints the timing means (with confidence
      intervals), standard deviations, minimums, medians, and maximums having
      done so. This can give a much better understanding of the command's
      performance.
    '';

    license = lib.licenses.mit;
    homepage = "https://tratt.net/laurie/src/multitime/";
    platforms = lib.platforms.unix;
    mainProgram = "multitime";
  };
}
