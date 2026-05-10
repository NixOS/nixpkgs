import ./generic.nix {
  hash = "sha256-7s2gc+78O8jKypVe1itaUrsLPa2mLjNgUUrR/cv7ITA=";
  version = "7.0.0";
  vendorHash = "sha256-6irMB3hpWcxDuMQBxWXnhMLAOwTAl63JX6JJZMQXf5E=";
  patches = fetchpatch2: [
    (fetchpatch2 {
      name = "doc-devices-disk_Fix-broken-link.patch";
      url = "https://github.com/lxc/incus/commit/faa636b70c05a5cca0346492a0586d5747e4b117.patch?full_index=1";
      hash = "sha256-UsfzSeLJq0B9xDmd124ITzFBJzg2w1xXNK6TavQ5iMs=";
    })
    (fetchpatch2 {
      name = "incusd-instance-qemu_Fix-version-detection-for-qemu-kvm.patch";
      url = "https://github.com/lxc/incus/commit/a5f50d36eaa41580f2233b05936bd29fe1b15100.patch?full_index=1";
      hash = "sha256-Qwu2oljB7COZB2m3W/9Y5wCCZyxvLj4ZUHcNqtoDGzk=";
    })
    (fetchpatch2 {
      name = "incusd_Re-introduce-core-scheduling-detection.patch";
      url = "https://github.com/lxc/incus/commit/1e6ce18e8cd92b5b3eb4346e7bd27fd4a7d1fb9b.patch?full_index=1";
      hash = "sha256-RLy8bcod55g8vtXxChte4oalApw7d/gZg8No6BUZQS0=";
    })
    (fetchpatch2 {
      name = "incusd-instance-lxc_Fix-swap=false-failure.patch";
      url = "https://github.com/lxc/incus/commit/5f2cdf7545c5398290dc507313de9ee547fe803f.patch?full_index=1";
      hash = "sha256-Ux6mm8Y4q68fj//hG7k+bXMjqhGDOxGNm64De1pwcYY=";
    })
    (fetchpatch2 {
      name = "incusd-forknet_Persist-DHCPv6-client-DUID-across-restarts.patch";
      url = "https://github.com/lxc/incus/commit/47377e345930e77d3fbce29d037fc7dbd6823dcf.patch?full_index=1";
      hash = "sha256-CWaNaDYuBBLahxkqnM0FQZraVkvBSbrx1+8dcB8Vfbg=";
    })
    (fetchpatch2 {
      name = "incusd-forknet_Include-FQDN-in-DHCPv6-INFO-requests.patch";
      url = "https://github.com/lxc/incus/commit/d7f1c9d75ca33eb2ddb0bf10cec934fd6e352089.patch?full_index=1";
      hash = "sha256-3zyADLiPUuiGLwdeISj5lUk3tkAayQGaRI+/yBHrvuM=";
    })
    (fetchpatch2 {
      name = "incusd-forknet_Properly-renew-stateful-DHCPv6.patch";
      url = "https://github.com/lxc/incus/commit/3b127758c17752302b3f4bf907f42e926ab664e4.patch?full_index=1";
      hash = "sha256-+dcdeZwuyTWH7yfPEDqKOax/lS1Yqvwn9ooqJxKD3jA=";
    })
    (fetchpatch2 {
      name = "incusd-forknet_Add-jitter-to-DHCPv6-renewal.patch";
      url = "https://github.com/lxc/incus/commit/2b24a260b6177c033047f270286933563f05a999.patch?full_index=1";
      hash = "sha256-grMspYyqn4Zl1Kn+hFeUfeIevdwszJc0x2YDC2JILKw=";
    })
    (fetchpatch2 {
      name = "incusd-device-nic_bridged_Fix-swapped-IPv4-IPv6-DNS-record.patch";
      url = "https://github.com/lxc/incus/commit/33ffcf71745e138dd4f3546839115c293e6be083.patch?full_index=1";
      hash = "sha256-E8Plz9qdoTt3id9I5jbZYMKQt+kUrKmXmtMJ6IXlRJg=";
    })
    (fetchpatch2 {
      name = "doc-authorization_Fix-reference-to-old-manager-relation.patch";
      url = "https://github.com/lxc/incus/commit/c65ac0f4e6e94859b8565bce41bbf1595f4a8085.patch?full_index=1";
      hash = "sha256-6wEz3uxWauIibBkH+OdB7+VsFySmugt6wk61qMayzYo=";
    })
    (fetchpatch2 {
      name = "incusd-network-acl_Fix-issue-with-instances-in-different-project-than-ACL.patch";
      url = "https://github.com/lxc/incus/commit/2a3584b6fccf152be42cf5614e54241bdb13e671.patch?full_index=1";
      hash = "sha256-CXE5Bowk3ZPup6oVDEJb9ucsJoXhXu/kU7gGCghhtjQ=";
    })
    (fetchpatch2 {
      name = "incusd-projects_Fix-targeting-on-project-delete.patch";
      url = "https://github.com/lxc/incus/commit/3a104e4dc24897f0d6543136bb1043fcd4a33632.patch?full_index=1";
      hash = "sha256-kTFkJqbjzdq5jvNxKw8YMPR04WRj4t5IS6ymoGyXDXE=";
    })
    (fetchpatch2 {
      name = "test-network_acl_Add-test-for-ACL-used-by-instance-in-different-project.patch";
      url = "https://github.com/lxc/incus/commit/41878729f06e9c31df9d4fac20fb8c384608577c.patch?full_index=1";
      hash = "sha256-YR2Akus4vp3vNvHEmsJUh/3gbEf3R/cFUOVvt9u/wEU=";
    })
    (fetchpatch2 {
      name = "incusd-instance-qemu_Remove-deprecated-QEMU-flag.patch";
      url = "https://github.com/lxc/incus/commit/c1f18c78fc6bc4850df20574bdcc541e5eefc4ac.patch?full_index=1";
      hash = "sha256-kbn4Yd/G23FCFA0Ch0+d81HUxCbcoiOzHfZ0MW+VlzE=";
    })
    (fetchpatch2 {
      name = "incusd-cluster_Re-order-evacuations-to-happen-earlier-on-shutdown.patch";
      url = "https://github.com/lxc/incus/commit/5b29ecc164ef28239d2e2a874a7c871a2e419083.patch?full_index=1";
      hash = "sha256-jpyJYjiZvRw/aOGsykEx8uotRBF7p1q5O08PVhyQtvk=";
    })
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
