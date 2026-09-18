{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2125";
    aarch64sha256 = "Zs4VKbFKkw4KRViX/QGVtVo4hluJ3HVen39Vq3Xz3KI=";
    x64sha256 = "0Zlv4nZMb2FDUG5KLkHTXJjdRzTa3TuNL54yacFVR/c=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2126";
    dev = true;
    aarch64sha256 = "sqrcGszq1Vi0DDbPds7ABsM7i1/6EEErTAC/Og3wwhc=";
    x64sha256 = "2Jia6Ep6iVz8PI6G2L52CEMnYpOK+MPZiwC/YVn3O9I=";
  } { };
}
