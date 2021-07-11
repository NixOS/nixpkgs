{ config, lib, utils, pkgs, ... }:
with lib;

let
  cfg = config.programs.defaults;
# This module defines an option to set 
# default programs and "Open with" associations.

# Why? No proper association. Inkspace pdf, dir vscode
# No proper order
# Home directory two of the most popular program mimeopen and xdg-open use differn

# [~/XDG/下载]
# $mimeopen -a resume.pdf                                                                                                      
# Please choose an application
# 
# 	1) Foxit Reader  (FoxitReader)
# 	2) Inkscape  (inkscape)
# 	3) Document Viewer  (org.gnome.Evince)
# 	4) pqiv  (pqiv)
# 	5) TeXworks  (texworks)
# 	6) Zathura  (org.pwmt.zathura)
# 
# use application #^C
# $xdg-open resume.pdf                                                                                                         
# 
# (zathura:9334): Gtk-WARNING **: 19:57:30.912: GModule (/nix/store/pbfflw3gldyxfqx3s1kddvh49anzqvbm-fcitx-with-plugins-4.2.9.6/lib/gtk-3.0/3.0.0/immodules/im-fcitx.so) initialization check failed: GLib version too old (micro mismatch)
# 
# (zathura:9334): Gtk-WARNING **: 19:57:30.912: Loading IM context type 'fcitx' failed

	singleEntryType = types.either types.str types.package;


  doesEndInDesktop = 
	  filePath: 
	  (
		  ( 
			  builtins.substring  
				  ( 
					  builtins.stringLength filePath  - 8
				  ) 
				  ( 
					  builtins.stringLength filePath - 1
				  ) 
				  filePath  
		  ) 
		  == 
			  ".desktop"
	)
  ;

  singleToList = 
	  val:  
		  if ( builtins.typeOf val != "list" ) 
		  then 
			  [ val ] 
		  else 
			  val 
  ;
  
	mapAttrValues = 
		f: set: 
			builtins.listToAttrs (
				 map 
					 (
						 attr: 
						 { 
							 name = attr; 
							 value = f set.${attr};
						 }
					 )
					 ( builtins.attrNames set ) 
			 )
	;

	getSingleDesktopFileFromPackage = pkg: 
	(
		builtins.elemAt
			( 
				builtins.filter 
					doesEndInDesktop
					( 
						builtins.attrNames( 
							builtins.readDir "${pkg}/share/applications"
						)
					) 
			) 
			0
	)
	;

	desktopFileNameFromPath = path:
		(
			let 
				nodes = builtins.split "/" path;
			in
				builtins.elemAt nodes ( ( builtins.length nodes ) - 1 )
		)
	;
	
	
	# list of mixed type, string and package
	packageFilter = launcherAttrOfList: 
		builtins.filter
			(
				p: ( builtins.typeOf p ) != "string"
			)
			( 
				builtins.concatLists
				( 
					builtins.attrValues launcherAttrOfList 
				)
			)
	;

	mixedListToDesktopFileList = mixedList:
		builtins.map
			(
				entry: 
				(
					if( builtins.typeOf entry == "string" )
					then
						desktopFileNameFromPath entry
					else
						( getSingleDesktopFileFromPackage entry )
				)
			)
			mixedList
	;

	defaultLaunchers = cfg.defaults;
	defaultLaunchersAttrOfList = 
		mapAttrValues 
			singleToList
			defaultLaunchers 
	;

	allDirectPackages = packageFilter defaultLaunchersAttrOfList;

	allCustomAssociations = mapAttrValues
		(
			mixedList: 
				builtins.concatStringsSep
					";"
					( mixedListToDesktopFileList mixedList )
		)
		defaultLaunchersAttrOfList 
	;


	mimeInfoCacheModifierScript  = 
		let
			scriptHeader = "customAssociations={}\n";

			dictionaryPopulationCode =
				builtins.concatStringsSep
					";\n"
					( 
						builtins.map
							(
								key: ''customAssociations["${key}"]="${allCustomAssociations.${key}}"''
							)
							( builtins.attrNames allCustomAssociations ) 
					)
			;

			logic = builtins.readFile( ./modifier.py );
		in
		( 
			pkgs.writeScript
				"mimeInfoCacheModifier"
				(	
					scriptHeader + 	dictionaryPopulationCode + "\n" + logic
				)
		)

	;

in
{
	options.programs.defaults = {
		defaults =
			mkOption {
				default = {};
				example = { 
					"application/pdf" = [ pkgs.zathura "${pkgs.evince}/share/applications/org.gnome.Evince.desktop" ];
					"inode/directory" = [ "${pkgs.spaceFM}/share/applications/spacefm.desktop" pkgs.ranger pkgs.vifm ];
					"video/mp4" = pkgs.vifm;
				} ;
				description = ''
					Set that defines default launcher programs. Attribute name is the mimetype, 
					and attribute values 
					A set where mimetypes are keys and an array of .desktop files, or packages
					are the values which would be used to open that file by default. 
				'';


				type = types.attrsOf (
					types.either 
						singleEntryType
						( types.listOf singleEntryType )
				) ;
			};
	};

	config = {
		environment.systemPackages = 
			allDirectPackages
		;

		environment.extraSetup = ''
			${pkgs.python3}/bin/python ${mimeInfoCacheModifierScript} $out/share/applications/mimeinfo.cache $out/share/applications/mimeinfo.cache
		'';
	};
}
