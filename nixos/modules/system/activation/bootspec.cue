import "struct"

#BootspecV1: {
	system:         string
	init:           string
	initrd?:        string
	initrdSecrets?: string
	kernel:         string
	kernelParams: [...string]
	label:    string
	toplevel: string
}

// A restricted document does not allow any official specialisation
// information in it to avoid "recursive specialisations".
#RestrictedDocument: struct.MinFields(1) & {
	"org.nixos.bootspec.v1": #BootspecV1
	[=~"^"]:                 #BootspecExtension
}

// Specialisations are a hashmap of strings
#BootspecSpecialisationV1: [string]: #RestrictedDocument

// Bootspec extensions are defined by the extension author.
#BootspecExtension: {...}

// A "full" document allows official specialisation information
// in the top-level with a reserved namespaced key.
Document: #RestrictedDocument & {
	"org.nixos.specialisation.v1"?: #BootspecSpecialisationV1
}
