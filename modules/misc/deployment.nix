{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
  
    deployment.targetEnv = mkOption {
      default = "none";
      example = "ec2";
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
      description = ''
        Specifies the type of cloud.  This affects the machine
        configuration.  Current values are <literal>"ec2"</literal>
        and <literal>"nova"</literal>.
      '';
    };

    deployment.ec2.controller = mkOption {
      example = https://ec2.eu-west-1.amazonaws.com:443/;
      description = ''
        URI of an Amazon EC2-compatible cloud controller web service,
        used to create and manage virtual machines.
      '';
    };

    deployment.ec2.ami = mkOption {
      example = "ami-ecb49e98";
      description = ''
        EC2 identifier of the AMI disk image used in the virtual
        machine.  This must be a NixOS image providing SSH access.
      '';
    };
    
    deployment.ec2.instanceType = mkOption {
      default = "m1.small";
      example = "m1.large";
      description = ''
        EC2 instance type.  See <link
        xlink:href='http://aws.amazon.com/ec2/instance-types/'/> for a
        list of valid Amazon EC2 instance types.
      '';
    };

    deployment.ec2.keyPair = mkOption {
      example = "my-keypair";
      description = ''
        Name of the SSH key pair to be used to communicate securely
        with the instance.  Key pairs can be created using the
        <command>ec2-add-keypair</command> command.
      '';
    };

    # Ad hoc cloud options.

    deployment.adhoc.controller = mkOption {
      example = "cloud.example.org";
      description = ''
        Hostname or IP addres of the machine to which
        <command>nixos-deploy-network</command> should connect (via
        SSH) to execute commands to start VMs or query their status.
      '';
    };
    
    deployment.adhoc.createVMCommand = mkOption {
      default = "create-vm";
      description = ''
        Remote command to create a NixOS virtual machine.  It should
        print an identifier denoting the VM on standard output.
      '';
    };
    
    deployment.adhoc.destroyVMCommand = mkOption {
      default = "destroy-vm";
      description = ''
        Remote command to destroy a previously created NixOS virtual
        machine.
      '';
    };
    
    deployment.adhoc.queryVMCommand = mkOption {
      default = "query-vm";
      description = ''
        Remote command to query information about a previously created
        NixOS virtual machine.  It should print the IPv6 address of
        the VM on standard output.
      '';
    };
    
  };
}
