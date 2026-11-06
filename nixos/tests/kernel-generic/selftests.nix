args: linuxPackages:
(import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    disabledTests = [
      # Failing tests
      "alsa:utimer-test"
      "capabilities:test_execve"
      "cgroup:test_freezer"
      "cgroup:test_kmem"
      "clone3:clone3_cap_checkpoint_restore"
      "core:unshare_test"
      "damon:sysfs_no_op_commit_break.py"
      "damon:sysfs_update_schemes_tried_regions_wss_estimation.py"
      "damon:sysfs.py"
      "devices/probe:test_discoverable_devices.py"
      "drivers/dma-buf:udmabuf"
      "drivers/net:hds.py"
      "drivers/net:netpoll_basic.py"
      "drivers/net:ping.py"
      "drivers/net:psp.py"
      "drivers/net:xdp.py"
      "drivers/ntsync:ntsync"
      "exec:execveat"
      "exec:non-regular"
      "filesystems/overlayfs:set_layers_via_fds"
      "hid:hid-apple.sh"
      "hid:hid-core.sh"
      "hid:hid-gamepad.sh"
      "hid:hid-ite.sh"
      "hid:hid-keyboard.sh"
      "hid:hid-mouse.sh"
      "hid:hid-multitouch.sh"
      "hid:hid-sony.sh"
      "hid:hid-tablet.sh"
      "hid:hid-wacom.sh"
      "iommu:iommufd"
      "kvm:dirty_log_page_splitting_test"
      "kvm:memslot_perf_test"
      "landlock:fs_test"
      "landlock:scoped_abstract_unix_test"
      "memfd:run_fuse_test.sh"
      "mount_setattr:mount_setattr_test"
      "mseal_system_mappings:sysmap_is_sealed"
      "nci:nci_dev"
      "net:gre_gso.sh"
      "net:pmtu.sh"
      "net:rtnetlink.sh"
      "net:test_bpf.sh"
      "net:test_ingress_egress_chaining.sh"
      "net:test_vxlan_fdb_changelink.sh"
      "net/forwarding:dual_vxlan_bridge.sh"
      "net/forwarding:gre_custom_multipath_hash.sh"
      "net/forwarding:gre_inner_v4_multipath.sh"
      "net/forwarding:gre_inner_v6_multipath.sh"
      "net/forwarding:gre_multipath_nh_res.sh"
      "net/forwarding:gre_multipath_nh.sh"
      "net/forwarding:gre_multipath.sh"
      "net/forwarding:ip6gre_custom_multipath_hash.sh"
      "net/forwarding:ip6gre_flat_key.sh"
      "net/forwarding:ip6gre_flat_keys.sh"
      "net/forwarding:ip6gre_flat.sh"
      "net/forwarding:ip6gre_hier_key.sh"
      "net/forwarding:ip6gre_hier_keys.sh"
      "net/forwarding:ip6gre_hier.sh"
      "net/forwarding:ip6gre_inner_v4_multipath.sh"
      "net/forwarding:ip6gre_inner_v6_multipath.sh"
      "net/forwarding:ipip_flat_gre_key.sh"
      "net/forwarding:ipip_flat_gre_keys.sh"
      "net/forwarding:ipip_flat_gre.sh"
      "net/forwarding:ipip_hier_gre_key.sh"
      "net/forwarding:ipip_hier_gre_keys.sh"
      "net/forwarding:ipip_hier_gre.sh"
      "net/forwarding:min_max_mtu.sh"
      "net/forwarding:mirror_gre_bound.sh"
      "net/forwarding:mirror_gre_bridge_1d_vlan.sh"
      "net/forwarding:mirror_gre_bridge_1d.sh"
      "net/forwarding:mirror_gre_bridge_1q.sh"
      "net/forwarding:mirror_gre_changes.sh"
      "net/forwarding:mirror_gre_flower.sh"
      "net/forwarding:mirror_gre_neigh.sh"
      "net/forwarding:mirror_gre_nh.sh"
      "net/forwarding:mirror_gre_vlan_bridge_1q.sh"
      "net/forwarding:mirror_gre.sh"
      "net/forwarding:q_in_vni_ipv6.sh"
      "net/forwarding:q_in_vni.sh"
      "net/forwarding:router_bridge_1d.sh"
      "net/forwarding:router_bridge_pvid_vlan_upper.sh"
      "net/forwarding:router_bridge_vlan_upper_pvid.sh"
      "net/forwarding:router_bridge_vlan_upper.sh"
      "net/forwarding:router_bridge_vlan.sh"
      "net/forwarding:router_bridge.sh"
      "net/forwarding:router_broadcast.sh"
      "net/forwarding:router_mpath_nh.sh"
      "net/forwarding:router_nh.sh"
      "net/forwarding:router_vid_1.sh"
      "net/forwarding:router.sh"
      "net/forwarding:sch_ets.sh"
      "net/forwarding:tc_flower_l2_miss.sh"
      "net/forwarding:tc_flower.sh"
      "net/forwarding:vxlan_asymmetric_ipv6.sh"
      "net/forwarding:vxlan_asymmetric.sh"
      "net/forwarding:vxlan_bridge_1d_ipv6.sh"
      "net/forwarding:vxlan_bridge_1d_port_8472_ipv6.sh"
      "net/forwarding:vxlan_bridge_1d_port_8472.sh"
      "net/forwarding:vxlan_bridge_1d.sh"
      "net/forwarding:vxlan_bridge_1q_ipv6.sh"
      "net/forwarding:vxlan_bridge_1q_mc_ul.sh"
      "net/forwarding:vxlan_bridge_1q_port_8472_ipv6.sh"
      "net/forwarding:vxlan_bridge_1q_port_8472.sh"
      "net/forwarding:vxlan_bridge_1q.sh"
      "net/forwarding:vxlan_reserved.sh"
      "net/forwarding:vxlan_symmetric_ipv6.sh"
      "net/forwarding:vxlan_symmetric.sh"
      "net/netfilter:conntrack_icmp_related.sh"
      "net/netfilter:nft_zones_many.sh"
      "net/openvswitch:openvswitch.sh"
      "net/ovpn:test-chachapoly.sh"
      "net/ovpn:test-close-socket-tcp.sh"
      "net/ovpn:test-close-socket.sh"
      "net/ovpn:test-float.sh"
      "net/ovpn:test-large-mtu.sh"
      "net/ovpn:test-tcp.sh"
      "net/ovpn:test.sh"
      "net/packetdrill:tcp_blocking_blocking-write.pkt"
      "net/packetdrill:tcp_nagle_https_client.pkt"
      "net/packetdrill:tcp_rcv_big_endseq.pkt"
      "net/packetdrill:tcp_rcv_toobig.pkt"
      "net/rds:run.sh"
      "openat2:resolve_test"
      "pci_endpoint:pci_endpoint_test"
      "perf_events:remove_on_exec"
      "pid_namespace:pid_max"
      "prctl:set-anon-vma-name-test"
      "proc:read"
      "pstore:pstore_tests"
      "ptrace:vmaccess"
      "rseq:syscall_errors_test"
      "seccomp:seccomp_benchmark"
      "sgx:test_sgx"
      "splice:short_splice_read.sh"
      "tc-testing:tdc.sh"
      "tdx:tdx_guest_test"
      "thermal/intel/power_floor:power_floor_test"
      "thermal/intel/workload_hint:workload_hint_test"
      "ublk:test_generic_01.sh"
      "ublk:test_generic_02.sh"
      "ublk:test_generic_03.sh"
      "ublk:test_generic_04.sh"
      "ublk:test_generic_05.sh"
      "ublk:test_generic_06.sh"
      "ublk:test_generic_07.sh"
      "ublk:test_generic_08.sh"
      "ublk:test_generic_09.sh"
      "ublk:test_generic_10.sh"
      "ublk:test_generic_11.sh"
      "ublk:test_generic_12.sh"
      "ublk:test_generic_13.sh"
      "ublk:test_loop_01.sh"
      "ublk:test_loop_02.sh"
      "ublk:test_loop_03.sh"
      "ublk:test_loop_04.sh"
      "ublk:test_loop_05.sh"
      "ublk:test_null_01.sh"
      "ublk:test_null_02.sh"
      "ublk:test_stress_01.sh"
      "ublk:test_stress_02.sh"
      "ublk:test_stress_03.sh"
      "ublk:test_stress_04.sh"
      "ublk:test_stress_05.sh"
      "ublk:test_stripe_01.sh"
      "ublk:test_stripe_02.sh"
      "ublk:test_stripe_03.sh"
      "ublk:test_stripe_04.sh"
      "uevent:uevent_filtering"
      "x86/bugs:its_indirect_alignment.py"
      "x86/bugs:its_permutations.py"
      "x86/bugs:its_ret_alignment.py"
      # Tests with issues
      # gets stuck
      "net/forwarding:tc_actions.sh"
      "kexec:test_kexec_jump"
      "kexec:test_kexec_jump.sh"
      # makes system unresponsive
      "breakpoints:step_after_suspend_test"
      # terminates execution of system
      "cgroup:test_cpu"
      "cgroup:test_memcontrol"
      "cgroup:test_zswap"
      "filesystems:file_stressor"
      # with_stress.sh: /usr/bin/true doesnt exist
      "cgroup:test_stress.sh"
      # takes long
      "connector:proc_filter"
      "drivers/net:napi_id.py"
      "kvm:demand_paging_test"
      "net:fcnal-ipv4.sh"
      "net:fcnal-ipv6.sh"
      "net/mptcp:mptcp_join.sh"
      "pidfd:pidfd_test"
      "rseq:run_param_test.sh"
      "mm:run_vmtests.sh"
      "x86:test_shadow_stack_64"
      "net:ipv6_route_update_soft_lockup.sh"
      # secure boot mode not enabled
      "kexec:test_kexec_load.sh"
      # missing addr2line
      "kvm:fix_hypercall_test"
      "kvm:msrs_test"
      # too much resources
      "kvm:mmu_stress_test"
      "net:fib_nexthops.sh"

    ];
    disabledTestsFile = pkgs.writeText "disabled-tests.txt" (lib.concatStringsSep "\n" disabledTests);
  in
  {
    name = "kernel-${linuxPackages.kernel.version}-selftests";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        joaosreis
      ];
    };

    globalTimeout = 9500;

    nodes.machine = {
      boot.kernelPackages = linuxPackages;

      virtualisation = {
        memorySize = 8 * 1024;
      };

      environment.systemPackages = with pkgs; [
        (writeShellScriptBin "run-kernel-selftests" ''
          cp -r ${lib.getLib linuxPackages.kernel.passthru.selftests} /root/selftests
          cd /root/selftests
          ./run_kselftest.sh -l > all_tests.txt
          grep -vxFf ${disabledTestsFile} all_tests.txt > kselftest-list.txt
          ./run_kselftest.sh
        '')
        (writeShellScriptBin "ping6" ''
          exec ${iputils}/bin/ping "$@"
        '')
        rsync
        llvmPackages.llvm
        jq
        ethtool
        (python3.withPackages (ps: [
          ps.pytest
          ps.pytest-tap
          hid-tools
        ]))
        linuxPackages.cpupower
        netsniff-ng
        smcroute
        tcpdump
        netperf
        tshark
        ndisc6
        iproute2
        nmap
        nftables
        packetdrill
        dropwatch
        socat
        iperf3
        pesign
        binutils
        bc
        inetutils
        fuse
        conntrack-tools
        procps
        systemd
      ];
    };

    testScript = ''
      machine.succeed("run-kernel-selftests > >(systemd-cat -t TEST) 2>&1")
    '';
    interactive.sshBackdoor.enable = true;
  }
) args)
