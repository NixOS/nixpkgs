{ stdenvNoCC, fetchurl, top ? false }:

import ./common.nix {
  inherit stdenvNoCC fetchurl;
  model = "resnet50";
  version = "2018-08-06";
  weights =
    if top
    then "resnet50_weights_tf_dim_ordering_tf_kernels.h5"
    else "resnet50_weights_tf_dim_ordering_tf_kernels_notop.h5";
  sha256 = "017m98glf5jm9qwsb64mki6s28by2qm3s3pkqidw3z7kmwyv9j36";
}
