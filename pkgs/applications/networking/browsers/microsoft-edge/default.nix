{
  dev = import ./browser.nix {
    channel = "dev";
    version = "121.0.2256.2";
    revision = "1";
    hash = "sha256-3QCyZVuXAUhaMOzD/JQ9ctKesilwyAn6NK6a1mxu3x4=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "120.0.2210.61";
    revision = "1";
    hash = "sha256-206Yk5CU3nL8cva0ZlK6aLraU8PURyeNL7vw90o3u0E=";
  };
  beta = import ./browser.nix {
    channel = "beta";
    version = "120.0.2210.61";
    revision = "1";
    hash = "sha256-XRO/Ry8zKFtBrDqbJsczmhi13XEmTdYMx4z/m/wWX8s=";
  };
}
