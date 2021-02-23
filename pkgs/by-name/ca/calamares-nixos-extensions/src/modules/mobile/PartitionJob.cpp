/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "PartitionJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"
#include "Settings.h"
#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QDir>
#include <QFileInfo>


PartitionJob::PartitionJob( const QString& cmdInternalStoragePrepare,
                            const QString& cmdLuksFormat,
                            const QString& cmdLuksOpen,
                            const QString& cmdMkfsRoot,
                            const QString& cmdMount,
                            const QString& targetDeviceRoot,
                            const QString& targetDeviceRootInternal,
                            bool installFromExternalToInternal,
                            bool isFdeEnabled,
                            const QString& password)
    : Calamares::Job()
    , m_cmdInternalStoragePrepare( cmdInternalStoragePrepare )
    , m_cmdLuksFormat( cmdLuksFormat )
    , m_cmdLuksOpen( cmdLuksOpen )
    , m_cmdMkfsRoot( cmdMkfsRoot )
    , m_cmdMount( cmdMount )
    , m_targetDeviceRoot( targetDeviceRoot )
    , m_targetDeviceRootInternal( targetDeviceRootInternal )
    , m_installFromExternalToInternal( installFromExternalToInternal )
    , m_isFdeEnabled( isFdeEnabled )
    , m_password( password )
{
}


QString
PartitionJob::prettyName() const
{
    return "Creating and formatting installation partition";
}

/* Fill the "global storage", so the following jobs (like unsquashfs) work.
   The code is similar to modules/partition/jobs/FillGlobalStorageJob.cpp in
   Calamares. */
void
FillGlobalStorage( const QString device, const QString pathMount )
{
    using namespace Calamares;

    GlobalStorage* gs = JobQueue::instance()->globalStorage();
    QVariantList partitions;
    QVariantMap partition;

    /* See mapForPartition() in FillGlobalStorageJob.cpp */
    partition[ "device" ] = device;
    partition[ "mountPoint" ] = "/";
    partition[ "claimed" ] = true;

    /* Ignored by calamares modules used in combination with the "mobile"
     * module, so we can get away with leaving them empty for now. */
    partition[ "uuid" ] = "";
    partition[ "fsName" ] = "";
    partition[ "fs" ] = "";

    partitions << partition;
    gs->insert( "partitions", partitions );
    gs->insert( "rootMountPoint", pathMount );
}

Calamares::JobResult
PartitionJob::exec()
{
    using namespace Calamares;
    using namespace CalamaresUtils;
    using namespace std;

    const QString pathMount = "/mnt/install";
    const QString cryptName = "calamares_crypt";
    QString cryptDev = "/dev/mapper/" + cryptName;
    QString passwordStdin = m_password + "\n";
    QString dev = m_targetDeviceRoot;
    QList< QPair< QStringList, QString > > commands = {};

    if ( m_installFromExternalToInternal )
    {
        dev = m_targetDeviceRootInternal;

        commands.append( {
            { { "sh", "-c", m_cmdInternalStoragePrepare }, QString() },
        } );
    }

    commands.append( { { { "mkdir", "-p", pathMount }, QString() } } );

    if ( m_isFdeEnabled )
    {
        commands.append( {
            { { "sh", "-c", m_cmdLuksFormat + " " + dev }, passwordStdin },
            { { "sh", "-c", m_cmdLuksOpen + " " + dev + " " + cryptName }, passwordStdin },
            { { "sh", "-c", m_cmdMkfsRoot + " " + cryptDev }, QString() },
            { { "sh", "-c", m_cmdMount + " " + cryptDev + " " + pathMount }, QString() },
        } );
    }
    else
    {
        commands.append( { { { "sh", "-c", m_cmdMkfsRoot + " " + dev }, QString() },
                           { { "sh", "-c", m_cmdMount + " " + dev + " " + pathMount }, QString() } } );
    }

    foreach ( auto command, commands )
    {
        const QStringList args = command.first;
        const QString stdInput = command.second;
        const QString pathRoot = "/";

        ProcessResult res
            = System::runCommand( System::RunLocation::RunInHost, args, pathRoot, stdInput, chrono::seconds( 120 ) );
        if ( res.getExitCode() )
        {
            return JobResult::error( "Command failed:<br><br>"
                                     "'"
                                     + args.join( " " )
                                     + "'<br><br>"
                                       " with output:<br><br>"
                                       "'"
                                     + res.getOutput() + "'" );
        }
    }

    FillGlobalStorage( m_isFdeEnabled ? cryptDev : dev, pathMount );
    return JobResult::ok();
}
