Ext.define('PBS.ServerAdministration', {
    extend: 'Ext.tab.Panel',
    alias: 'widget.pbsServerAdministration',

    title: gettext('Server Administration'),

    border: true,
    defaults: { border: false },

    tools: [PBS.Utils.get_help_tool('sysadmin-host-administration')],

    items: [
        {
            xtype: 'pbsServerStatus',
            itemId: 'status',
            iconCls: 'fa fa-area-chart',
        },
        {
            xtype: 'proxmoxNodeTasks',
            itemId: 'tasks',
            iconCls: 'fa fa-list-alt',
            title: gettext('Tasks'),
            height: 'auto',
            nodename: 'localhost',
            extraFilter: [
                {
                    xtype: 'pbsDataStoreSelector',
                    fieldLabel: gettext('Datastore'),
                    emptyText: gettext('All'),
                    name: 'store',
                    allowBlank: true,
                },
            ],
        },
    ],
});
