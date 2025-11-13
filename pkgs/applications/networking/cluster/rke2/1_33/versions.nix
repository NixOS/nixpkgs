{
  rke2Version = "1.33.5+rke2r1";
  rke2Commit = "d1092839cf08cb901b1d40461b0fa6e7ae6f8fc4";
  rke2TarballHash = "sha256-u+pSJXcQ2KGs9VNi/ikV7lOVgwOeLBjhS/U3zwHE8ok=";
  rke2VendorHash = "sha256-UouTBZUve+0dWzJU46rKGfo8BE/pYS/JSP9OsJnGGLM=";
  k8sImageTag = "v1.33.5-rke2r1-build20250910";
  etcdVersion = "v3.5.21-k3s1-build20250910";
  pauseVersion = "3.6";
  ccmVersion = "v1.33.4-rc1.0.20250814212538-148243c49519-build20250908";
  dockerizedVersion = "v1.33.5-rke2r1";
  imagesVersions = with builtins; fromJSON (readFile ./images-versions.json);
}
