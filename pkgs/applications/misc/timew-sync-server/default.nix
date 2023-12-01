{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timew-sync-server";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GaDcnPJBcDJ3AQaHzifDgdl0QT4GSbAOIqp4RrAcO3M=";
  };

  vendorHash = "sha256-iROqiRWkHG6N6kivUmgmu6sg14JDdG4f98BdR7CL1gs=";

  meta = with lib; {
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-server";
    description = "Server component of timewarrior synchronization application";
    license = licenses.mit;
    maintainers = [ maintainers.joachimschmidt557 ];
    platforms = platforms.linux;
  };
}
