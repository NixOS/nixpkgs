{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "timew-sync-server";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "timewarrior-synchronize";
    repo = pname;
    rev = "v${version}";
    sha256 = "041j618c2bcryhgi2j2w5zlfcxcklgbir2xj3px4w7jxbbg6p68n";
  };

  vendorSha256 = "0wbd4cpswgbr839sk8qwly8gjq4lqmq448m624akll192mzm9wj7";

  meta = with lib; {
    homepage = "https://github.com/timewarrior-synchronize/timew-sync-server";
    description = "Server component of timewarrior synchronization application";
    license = licenses.mit;
    maintainers = [ maintainers.joachimschmidt557 ];
    platforms = platforms.linux;
  };
}
