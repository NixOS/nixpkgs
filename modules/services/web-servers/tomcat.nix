{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      tomcat = {
        enable = mkOption {
          default = false;
          description = "Whether to enable Apache Tomcat";
        };
        
        baseDir = mkOption {
          default = "/var/tomcat";
          description = "Location where Tomcat stores configuration files, webapplications and logfiles";
        };
        
        user = mkOption {
          default = "tomcat";
          description = "User account under which Apache Tomcat runs.";
        };      
        
	group = mkOption {
          default = "tomcat";
          description = "Group account under which Apache Tomcat runs.";
        };      
        
        javaOpts = mkOption {
          default = "";
          description = "Parameters to pass to the Java Virtual Machine which spawns Apache Tomcat";
        };
        
        catalinaOpts = mkOption {
          default = "";
          description = "Parameters to pass to the Java Virtual Machine which spawns the Catalina servlet container";
        };
        
        sharedLibs = mkOption {
          default = [];
          description = "List containing JAR files or directories with JAR files which are libraries shared by the web applications";
        };
        
        commonLibs = mkOption {
          default = [];
          description = "List containing JAR files or directories with JAR files which are libraries shared by the web applications and the servlet container";
        };
	
	webapps = mkOption {
	  default = [ pkgs.tomcat6 ];
	  description = "List containing WAR files or directories with WAR files which are web applications to be deployed on Tomcat";
	};
	
	virtualHosts = mkOption {
	  default = [];
	  description = "List consisting of a virtual host name and a list of web applications to deploy on each virtual host";
	};
	
	axis2 = {
	  enable = mkOption {
	    default = false;
	    description = "Whether to enable an Apache Axis2 container";
	  };
	  
	  services = mkOption {
	    default = [];
	    description = "List containing AAR files or directories with AAR files which are web services to be deployed on Axis2";
	  };
	};
      };
    };
  };
in

###### implementation

let
  cfg = config.services.tomcat;
in

mkIf config.services.tomcat.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{
      name = "tomcat";
      
      groups = [
        { name = "tomcat";
          gid = config.ids.gids.tomcat;
        }
      ];
      
      users = [
        { name = "tomcat";
          uid = config.ids.uids.tomcat;
          description = "Tomcat user";
          home = "/homeless-shelter";
        }
      ];
      
      job = ''
        description "Apache Tomcat server"

        start on network-interface/started
        stop on network-interfaces/stop
        
        start script
	    rm -Rf ${cfg.baseDir}
	    
	    # Create the base directory
	    mkdir -p ${cfg.baseDir}
	    
	    # Create a symlink to the bin directory of the tomcat component
	    ln -sf ${pkgs.tomcat6}/bin ${cfg.baseDir}/bin
	    
	    # Create a conf/ directory
	    mkdir -p ${cfg.baseDir}/conf
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/conf
	    
	    # Symlink the config files in the conf/ directory (except for catalina.properties and server.xml)
	    for i in $(ls ${pkgs.tomcat6}/conf | grep -v catalina.properties server.xml)
	    do
	        ln -sf ${pkgs.tomcat6}/conf/$i ${cfg.baseDir}/conf/`basename $i`
	    done
	    
	    # Create a modified catalina.properties file 
	    # Change all references from CATALINA_HOME to CATALINA_BASE and add support for shared libraries
	    sed -e 's|''${catalina.home}|''${catalina.base}|g' \
                -e 's|shared.loader=|shared.loader=''${catalina.base}/shared/lib/*.jar|' \
		${pkgs.tomcat6}/conf/catalina.properties > ${cfg.baseDir}/conf/catalina.properties
	    
	    # Create a modified server.xml which also includes all virtual hosts
	    sed -e "/<Engine name=\"Catalina\" defaultHost=\"localhost\">/a\  ${toString (map (virtualHost: ''<Host name=\"${virtualHost.name}\" appBase=\"virtualhosts/${virtualHost.name}/webapps\" unpackWARs=\"true\" autoDeploy=\"true\" xmlValidation=\"false\" xmlNamespaceAware=\"false\" />'' ) cfg.virtualHosts)}" \
	        ${pkgs.tomcat6}/conf/server.xml > ${cfg.baseDir}/conf/server.xml
	    
	    # Create a logs/ directory
	    mkdir -p ${cfg.baseDir}/logs
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/logs
	    
	    # Create a temp/ directory
	    mkdir -p ${cfg.baseDir}/temp
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/temp

	    # Create a lib/ directory	    
	    mkdir -p ${cfg.baseDir}/lib
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/lib
	    	    
	    # Create a shared/lib directory
	    mkdir -p ${cfg.baseDir}/shared/lib
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/shared/lib
	    
	    # Create a webapps/ directory
	    mkdir -p ${cfg.baseDir}/webapps
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/webapps
	    
	    # Symlink all the given common libs files or paths into the lib/ directory
	    for i in ${pkgs.tomcat6} ${toString cfg.commonLibs}
	    do
		if [ -f $i ]
		then
		    # If the given web application is a file, symlink it into the common/lib/ directory
		    ln -sf $i ${cfg.baseDir}/lib/`basename $i`
		elif [ -d $i ]
		then
		    # If the given web application is a directory, then iterate over the files
		    # in the special purpose directories and symlink them into the tomcat tree
		    
		    for j in $i/lib/*
		    do
			ln -sf $j ${cfg.baseDir}/lib/`basename $j`
		    done
		fi
	    done	    	     

	    # Symlink all the given shared libs files or paths into the shared/lib/ directory
	    for i in ${toString cfg.sharedLibs}
	    do
		if [ -f $i ]
		then
		    # If the given web application is a file, symlink it into the common/lib/ directory
		    ln -sf $i ${cfg.baseDir}/shared/lib/`basename $i`
		elif [ -d $i ]
		then
		    # If the given web application is a directory, then iterate over the files
		    # in the special purpose directories and symlink them into the tomcat tree
		    
		    for j in $i/shared/lib/*
		    do
			ln -sf $j ${cfg.baseDir}/shared/lib/`basename $j`
		    done
		fi
	    done 
	    
	    # Symlink all the given web applications files or paths into the webapps/ directory
	    for i in ${toString cfg.webapps}
	    do
		if [ -f $i ]
		then
		    # If the given web application is a file, symlink it into the webapps/ directory
		    ln -sf $i ${cfg.baseDir}/webapps/`basename $i`
		elif [ -d $i ]
		then
		    # If the given web application is a directory, then iterate over the files
		    # in the special purpose directories and symlink them into the tomcat tree
		    
		    for j in $i/webapps/*
		    do
		        ln -sf $j ${cfg.baseDir}/webapps/`basename $j`
		    done
		fi
	    done	    	    
	    
	    ${toString (map (virtualHost: ''
	      # Create webapps directory for the virtual host
	      mkdir -p ${cfg.baseDir}/virtualhosts/${virtualHost.name}/webapps
	      
	      # Modify ownership
	      chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/virtualhosts/${virtualHost.name}/webapps
	      
	      # Symlink all the given web applications files or paths into the webapps/ directory
	      # of this virtual host
	      for i in ${toString virtualHost.webapps}
	      do
		  if [ -f $i ]
		  then
		      # If the given web application is a file, symlink it into the webapps/ directory
		      ln -sf $i ${cfg.baseDir}/virtualhosts/${virtualHost.name}/webapps/`basename $i`
		  elif [ -d $i ]
		  then
		      # If the given web application is a directory, then iterate over the files
		      # in the special purpose directories and symlink them into the tomcat tree
		    
		      for j in $i/webapps/*
		      do
		          ln -sf $j ${cfg.baseDir}/virtualhosts/${virtualHost.name}/webapps/`basename $j`
		      done
                  fi	                  
	      done
	      
	      ''
	    ) cfg.virtualHosts) }
	    
	    # Create a work/ directory
	    mkdir -p ${cfg.baseDir}/work
	    chown ${cfg.user}:${cfg.group} ${cfg.baseDir}/work
	    
	    ${if cfg.axis2.enable == true then
		''
		# Copy the Axis2 web application
		cp -av ${pkgs.axis2}/webapps/axis2 ${cfg.baseDir}/webapps
		
		# Turn off addressing, which causes many errors
		sed -i -e 's%<module ref="addressing"/>%<!-- <module ref="addressing"/> -->%' ${cfg.baseDir}/webapps/axis2/WEB-INF/conf/axis2.xml
		
		# Modify permissions on the Axis2 application
		chown -R ${cfg.user}:${cfg.group} ${cfg.baseDir}/webapps/axis2
				
		# Symlink all the given web service files or paths into the webapps/axis2/WEB-INF/services directory
		for i in ${toString cfg.axis2.services}
		do
		    if [ -f $i ]
		    then
			# If the given web service is a file, symlink it into the webapps/axis2/WEB-INF/services
			ln -sf $i ${cfg.baseDir}/webapps/axis2/WEB-INF/services/`basename $i`
		    elif [ -d $i ]
		    then
			# If the given web application is a directory, then iterate over the files
		        # in the special purpose directories and symlink them into the tomcat tree
			
			for j in $i/webapps/axis2/WEB-INF/services/*
			do
			    ln -sf $j ${cfg.baseDir}/webapps/axis2/WEB-INF/services/`basename $j`
			done
		    fi
		done    
		''
	    else ""}
        end script
        
        respawn ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c 'CATALINA_BASE=${cfg.baseDir} JAVA_HOME=${pkgs.jdk} JAVA_OPTS="${cfg.javaOpts}" CATALINA_OPTS="${cfg.catalinaOpts}" ${pkgs.tomcat6}/bin/startup.sh; sleep 1000d'
        
        stop script
            echo "Stopping tomcat..."
            CATALINA_BASE=${cfg.baseDir} JAVA_HOME=${pkgs.jdk} ${pkgs.su}/bin/su -s ${pkgs.bash}/bin/sh ${cfg.user} -c ${pkgs.tomcat6}/bin/shutdown.sh
        end script
      '';
    }];
  };
}
