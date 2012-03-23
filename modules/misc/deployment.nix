{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.deployment; in

{
  options = {

    deployment.targetEnv = mkOption {
      default = "none";
      example = "ec2";
      type = types.uniq types.string;
      description = ''
        This option specifies the type of the environment in which the
        machine is to be deployed by
        <command>nixos-deploy-network</command>.  Currently, it can
        have the following values. <literal>"none"</literal> means
        deploying to a pre-existing physical or virtual NixOS machine,
        reachable via SSH under the hostname or IP address specified
        in <option>deployment.targetHost</option>.
        <literal>"ec2"</literal> means that a virtual machine should be
        instantiated in an Amazon EC2-compatible cloud environment
        (see <option>deployment.ec2.*</option>).
        <literal>"adhoc-cloud"</literal> means that a virtual machine
        should be instantiated by executing certain commands via SSH
        on a cloud controller machine (see
        <option>deployment.adhoc.*</option>).  This is primarily
        useful for debugging <command>nixos-deploy-network</command>.
      '';
    };

    deployment.targetHost = mkOption {
      default = config.networking.hostName;
      type = types.uniq types.string;
      description = ''
        This option specifies a hostname or IP address which can be
        used by <command>nixos-deploy-network</command> to execute
        remote deployment operations.
      '';
    };

    # EC2/Nova/Eucalyptus-specific options.

    deployment.ec2.type = mkOption {
      default = "ec2";
      example = "nova";
      type = types.uniq types.string;
      description = ''
        Specifies the type of cloud.  This affects the machine
        configuration.  Current values are <literal>"ec2"</literal>
        and <literal>"nova"</literal>.
      '';
    };

    deployment.ec2.controller = mkOption {
      example = https://ec2.eu-west-1.amazonaws.com/;
      type = types.uniq types.string;
      description = ''
        URI of an Amazon EC2-compatible cloud controller web service,
        used to create and manage virtual machines.  If you're using
        EC2, it's more convenient to set
        <option>deployment.ec2.region</option>.
      '';
    };

    deployment.ec2.region = mkOption {
      default = "";
      example = "us-east-1";
      type = types.uniq types.string;
      description = ''
        Amazon EC2 region in which the instance is to be deployed.
        This option only applies when using EC2.  It implicitly sets
        <option>deployment.ec2.controller</option> and
        <option>deployment.ec2.ami</option>.
      '';
    };

    deployment.ec2.ami = mkOption {
      example = "ami-ecb49e98";
      type = types.uniq types.string;
      description = ''
        EC2 identifier of the AMI disk image used in the virtual
        machine.  This must be a NixOS image providing SSH access.
      '';
    };

    deployment.ec2.instanceType = mkOption {
      default = "m1.small";
      example = "m1.large";
      type = types.uniq types.string;
      description = ''
        EC2 instance type.  See <link
        xlink:href='http://aws.amazon.com/ec2/instance-types/'/> for a
        list of valid Amazon EC2 instance types.
      '';
    };

    deployment.ec2.keyPair = mkOption {
      example = "my-keypair";
      type = types.uniq types.string;
      description = ''
        Name of the SSH key pair to be used to communicate securely
        with the instance.  Key pairs can be created using the
        <command>ec2-add-keypair</command> command.
      '';
    };

    deployment.ec2.securityGroups = mkOption {
      default = [ "default" ];
      example = [ "my-group" "my-other-group" ];
      type = types.list types.string;
      description = ''
        Security groups for the instance.  These determine the
        firewall rules applied to the instance.
      '';
    };

    # Ad hoc cloud options.

    deployment.adhoc.controller = mkOption {
      example = "cloud.example.org";
      type = types.uniq types.string;
      description = ''
        Hostname or IP addres of the machine to which
        <command>nixos-deploy-network</command> should connect (via
        SSH) to execute commands to start VMs or query their status.
      '';
    };

    deployment.adhoc.createVMCommand = mkOption {
      default = "create-vm";
      type = types.uniq types.string;
      description = ''
        Remote command to create a NixOS virtual machine.  It should
        print an identifier denoting the VM on standard output.
      '';
    };

    deployment.adhoc.destroyVMCommand = mkOption {
      default = "destroy-vm";
      type = types.uniq types.string;
      description = ''
        Remote command to destroy a previously created NixOS virtual
        machine.
      '';
    };

    deployment.adhoc.queryVMCommand = mkOption {
      default = "query-vm";
      type = types.uniq types.string;
      description = ''
        Remote command to query information about a previously created
        NixOS virtual machine.  It should print the IPv6 address of
        the VM on standard output.
      '';
    };

    # VirtualBox options.

    deployment.virtualbox.baseImage = mkOption {
      example = "/home/alice/base-disk.vdi";
      description = ''
        Path to the initial disk image used to bootstrap the
        VirtualBox instance.  The instance boots from a clone of this
        image.
      '';
    };

    # Computed options useful for referring to other machines in
    # network specifications.

    networking.privateIPv4 = mkOption {
      example = "10.1.2.3";
      type = types.uniq types.string;
      description = ''
        IPv4 address of this machine within in the logical network.
        This address can be used by other machines in the logical
        network to reach this machine.  However, it need not be
        visible to the outside (i.e., publicly routable).
      '';
    };

    networking.publicIPv4 = mkOption {
      example = "198.51.100.123";
      type = types.uniq types.string;
      description = ''
        Publicly routable IPv4 address of this machine.
      '';
    };

  };


  config = {
  
    deployment.ec2 = mkIf (cfg.ec2.region != "") {
    
      controller = mkDefault "https://ec2.${cfg.ec2.region}.amazonaws.com/";

      # The list below is generated by running the "create-amis.sh" script, then doing:
      # $ while read system region ami; do echo "        if cfg.ec2.region == \"$region\" && config.nixpkgs.system == \"$system\" then \"$ami\" else"; done < amis
      ami = mkDefault (
        if cfg.ec2.region == "eu-west-1" && config.nixpkgs.system == "x86_64-linux" then "ami-65dae711" else
        if cfg.ec2.region == "eu-west-1" && config.nixpkgs.system == "i686-linux"   then "ami-dd90a9a9" else
        if cfg.ec2.region == "us-east-1" && config.nixpkgs.system == "x86_64-linux" then "ami-95bb72fc" else
        if cfg.ec2.region == "us-west-1" && config.nixpkgs.system == "x86_64-linux" then "ami-0b0c534e" else
        # !!! Doesn't work, not lazy enough.
        # throw "I don't know an AMI for region ‘${cfg.ec2.region}’ and platform type ‘${config.nixpkgs.system}’"
        "");
        
    };

    deployment.virtualbox = {

      baseImage = mkDefault (
        let
          unpack = name: sha256: pkgs.runCommand "virtualbox-charon-${name}.vdi" {}
            ''
              xz -d < ${pkgs.fetchurl {
                url = "http://nixos.org/releases/nixos/virtualbox-charon-images/virtualbox-charon-${name}.vdi.xz";
                inherit sha256;
              }} > $out
            '';
        in if config.nixpkgs.system == "x86_64-linux" then
          unpack "r33382-x86_64" "16irymms7vs4l3cllbpfl572269dwmlc7zficzf0r05bx7l0jsax"
        else if config.nixpkgs.system == "i686-linux" then /foo/disk.vdi else
          throw "Unsupported VirtualBox system type!"
      );
    
    };
        
  };
  
}
