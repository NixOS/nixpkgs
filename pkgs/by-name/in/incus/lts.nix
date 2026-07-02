import ./generic.nix {
  hash = "sha256-7s2gc+78O8jKypVe1itaUrsLPa2mLjNgUUrR/cv7ITA=";
  version = "7.0.0";
  vendorHash = "sha256-6irMB3hpWcxDuMQBxWXnhMLAOwTAl63JX6JJZMQXf5E=";
  lts = true;
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
    (fetchpatch2 {
      name = "incusd-storage_Fix-unsafe-access-to-backup-data.patch";
      url = "https://github.com/lxc/incus/commit/d71c5053a4c8318e6eb07337a7a4a07a6608ef73.patch?full_index=1";
      hash = "sha256-/mH0/KmX9sG8HZTcdk8MT+QZtNqZa934wcHptvdVtXM=";
    })
    (fetchpatch2 {
      name = "incusd-storage_Guard-nil-ExpiresAt-in-CreateCustomVolumeFromBackup.patch";
      url = "https://github.com/lxc/incus/commit/ab6b7dff0c770044875d9d26a6254a7075b4d00b.patch?full_index=1";
      hash = "sha256-d7VUetQzUTBq3GLYM1JKy2KDbBxOW5Lg7Di1/JPNzSE=";
    })
    (fetchpatch2 {
      name = "incusd-storage_Guard-nil-fields-in-createDependentVolumesFromBackup.patch";
      url = "https://github.com/lxc/incus/commit/98e64f0a6fcfdc9676eea0246418d490c53297bf.patch?full_index=1";
      hash = "sha256-+lB7eHsGZ/dW7aL4/wIWD4AF6t7s4QYfAld1bQOw2tQ=";
    })
    (fetchpatch2 {
      name = "incusd-storage-s3_Confine-multipart-uploads-with-os.Root.patch";
      url = "https://github.com/lxc/incus/commit/a6012422b45c86f3b1956788cff5d75c604ad838.patch?full_index=1";
      hash = "sha256-u3NLKE8Rh8i6HMbJ0KNhH7gbuwIpJ1SPqiyVoiuw9Sc=";
    })
    (fetchpatch2 {
      name = "incusd-instances_Check-source-instance-access-on-copy.patch";
      url = "https://github.com/lxc/incus/commit/1e3ffc53a10950e55de62ac1e0d612be597b84eb.patch?full_index=1";
      hash = "sha256-1foxIu1rWcK1QbpmAPoQ46Tl1mrPvoctPnDhKRTWbd0=";
    })
    (fetchpatch2 {
      name = "incusd-storage_Check-source-volume-access-on-copy.patch";
      url = "https://github.com/lxc/incus/commit/2e01078366e2653712719dec82318e51c6d21b28.patch?full_index=1";
      hash = "sha256-FP9v/8V0ZFLgy1tODKLJlw5f/6qJ8AMP/yme2YhYSaA=";
    })
    (fetchpatch2 {
      name = "incusd-images_Validate-fingerprint-on-direct-download.patch";
      url = "https://github.com/lxc/incus/commit/46d6ef232186df5535c49ca9f3597cab381f9b86.patch?full_index=1";
      hash = "sha256-R8gsvdmb7KVC6W1vFH1CojzhrGNgNiFOOTYbCrDAajg=";
    })
    (fetchpatch2 {
      name = "shared-validate_Reject-compression-algorithm-arguments.patch";
      url = "https://github.com/lxc/incus/commit/873a032a461df6b09b7586435b592873863a4e88.patch?full_index=1";
      hash = "sha256-QvxGxwHvswUZFst71zA12ZdxNIErl1LkaNyQdcPiglI=";
    })
    (fetchpatch2 {
      name = "incusd-instance_Confine-template-access-to-instance-root.patch";
      url = "https://github.com/lxc/incus/commit/cbefa31ae0da8fd96361178aed3a3c631e098fef.patch?full_index=1";
      hash = "sha256-ZOHqnlIG6LyIUO6WP76SZJKTeqoiw9qj2YByGxqGP+E=";
    })
    (fetchpatch2 {
      name = "incusd-instance_Enforce-project-restrictions-on-snapshot-restore.patch";
      url = "https://github.com/lxc/incus/commit/3fe3bc99891940fcd3e758d49f65a853104fcd6b.patch?full_index=1";
      hash = "sha256-j+lTbDaUjnZRY0lmaOSH4oKNAeIe5GXTwd1oM50it+Y=";
    })
    (fetchpatch2 {
      name = "incusd-exec_Reject-exec-output-symlink.patch";
      url = "https://github.com/lxc/incus/commit/e109655d642c7cb7c9039b7c06323000407f76dd.patch?full_index=1";
      hash = "sha256-v/H12n8u+aqm9+ZxrarBxQEQSMN1gpX13oyummGWXl8=";
    })
    (fetchpatch2 {
      name = "incusd_Reject-rootfs-symlink-for-instances.patch";
      url = "https://github.com/lxc/incus/commit/7e58425ca7ffeb21bb116869e71a0d002dae9e72.patch?full_index=1";
      hash = "sha256-MU+Khx+DhYQWUVs71D05PnJGamrhRXxsahtdXZeSfvU=";
    })
    (fetchpatch2 {
      name = "shared-logger_Add-WarnOnError-helper.patch";
      url = "https://github.com/lxc/incus/commit/1bc4d3feb8cd3bd005b7406c0d44ad3ea59400bf.patch?full_index=1";
      hash = "sha256-ima4IGl0CyL30yZVdQ2pmp9SukIzrdBftGkO/GUPB3g=";
    })
    (fetchpatch2 {
      name = "incus-0001-incusd-daemon_images-Add-missing-import.patch";
      url = "https://raw.githubusercontent.com/zabbly/incus/a7fd42d2f5115c4e6893b23e64209db511fff828/patches/incus-0001-incusd-daemon_images-Add-missing-import.patch";
      hash = "sha256-xtuuASy9bck+BgXbea9goNhrMV8Yme9cmFp4WNrkIdI=";
    })
  ];
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
