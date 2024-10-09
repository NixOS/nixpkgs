{
  stable = {
    chromedriver = {
      hash_darwin = "sha256-/0mBZCSNULvZSQ/irsQSgNPsuOSWiRRnJA/6ogHYeGk=";
      hash_darwin_aarch64 =
        "sha256-JWcYFYaaXM2KN6oSu7wwxztYPbhql2XYZlvL2ymKgwI=";
      hash_linux = "sha256-odFoTWjDa9ilyOrQ0T+0xxedRD7YOe/s7xdAyyku74w=";
      version = "129.0.6668.91";
    };
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
    };
    hash = "sha256-LOZ9EPw7VgBNEV7Wxb8H5WfSYTTWOL8EDP91uCrZAsA=";
    version = "129.0.6668.100";
  };
  ungoogled-chromium = {
    deps = {
      gn = {
        hash = "sha256-8o3rDdojqVHMQCxI2T3MdJOXKlW3XX7lqpy3zWhJiaA=";
        rev = "d010e218ca7077928ad7c9e9cc02fe43b5a8a0ad";
        url = "https://gn.googlesource.com/gn";
        version = "2024-08-19";
      };
      ungoogled-patches = {
        hash = "sha256-kvpLE6SbXFur5xi1C8Ukvm4OoU5YB8PQCJdiakhFSAM=";
        rev = "129.0.6668.100-1";
      };
    };
    hash = "sha256-LOZ9EPw7VgBNEV7Wxb8H5WfSYTTWOL8EDP91uCrZAsA=";
    version = "129.0.6668.100";
  };
}
